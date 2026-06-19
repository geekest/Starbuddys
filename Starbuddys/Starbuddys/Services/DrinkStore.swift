import Foundation
import UIKit
import Combine

/// 统一的饮品持久化存储服务（单例）
/// 内置饮品（seed）与用户新增饮品均存储于 Documents/all_drinks.json
@MainActor
final class DrinkStore: ObservableObject {
    static let shared = DrinkStore()

    /// 不含已删除条目的公开列表（供饮品库展示）
    @Published private(set) var entries: [DrinkEntry] = []
    /// 全量条目（含逻辑删除），供历史记录查询
    private(set) var allEntries: [DrinkEntry] = []

    private var storeURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("all_drinks.json")
    }

    private var legacyStoreURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("user_drinks.json")
    }

    private init() {
        load()
        seedIfNeeded()
    }

    // MARK: - 读取

    private func load() {
        guard let data = try? Data(contentsOf: storeURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = (try? decoder.decode([DrinkEntry].self, from: data)) ?? []
        allEntries = decoded
        entries    = decoded.filter { !$0.isHidden }
    }

    // MARK: - 首次启动 seeding

    private func seedIfNeeded() {
        let key = "DrinkStore.seeded_v1"
        guard !UserDefaults.standard.bool(forKey: key) else { return }

        var seeded: [DrinkEntry] = []

        // 将内置 seed 文件转换为 DrinkEntry
        for name in ["drinks.seed", "manner.seed", "luckin.seed"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let seedData = try? JSONDecoder().decode(DrinkSeedData.self, from: data) else { continue }
            seeded.append(contentsOf: seedData.drinks.map { DrinkEntry(from: $0) })
        }

        // 迁移旧 user_drinks.json（DrinkEntry 的 decodeIfPresent 兼容旧格式）
        if let data = try? Data(contentsOf: legacyStoreURL) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let migrated = (try? decoder.decode([DrinkEntry].self, from: data)) ?? []
            seeded.append(contentsOf: migrated)
        }

        allEntries = seeded
        entries    = seeded.filter { !$0.isHidden }
        persistRaw()
        UserDefaults.standard.set(true, forKey: key)
    }

    // MARK: - 写入

    private func persist() {
        persistRaw()
        entries = allEntries.filter { !$0.isHidden }
    }

    private func persistRaw() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(allEntries) else { return }
        try? data.write(to: storeURL, options: .atomic)
    }

    // MARK: - CRUD

    func add(_ entry: DrinkEntry) {
        allEntries.append(entry)
        persist()
    }

    func update(_ entry: DrinkEntry) {
        guard let idx = allEntries.firstIndex(where: { $0.id == entry.id }) else { return }
        allEntries[idx] = entry
        persist()
    }

    /// 逻辑删除：标记为 isHidden=true，不影响历史记录
    func hide(id: String) {
        guard let idx = allEntries.firstIndex(where: { $0.id == id }) else { return }
        allEntries[idx].isHidden = true
        persist()
    }

    /// 按 id 查找条目（含已删除）
    func entry(id: String) -> DrinkEntry? {
        allEntries.first { $0.id == id }
    }

    // MARK: - 照片管理

    private func documentsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    /// 将 JPEG 数据写入 Documents 目录并返回文件名
    func savePhoto(data: Data, entryID: String) -> String {
        let name = "user_drink_\(entryID).jpg"
        let url  = documentsURL().appendingPathComponent(name)
        try? data.write(to: url, options: .atomic)
        return name
    }

    /// 根据文件名从 Documents 目录加载 UIImage
    func loadPhoto(fileName: String) -> UIImage? {
        let url = documentsURL().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }

    /// 根据文件名构造完整 URL
    func photoURL(for fileName: String) -> URL {
        documentsURL().appendingPathComponent(fileName)
    }
}
