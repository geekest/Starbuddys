import Foundation
import UIKit
import Combine

/// 用户自建饮品的持久化存储服务（单例），数据以 JSON 文件存于 Documents 目录
@MainActor
final class UserDrinkStore: ObservableObject {
    static let shared = UserDrinkStore()

    /// 不含已删除条目的公开列表（供饮品库展示）
    @Published private(set) var entries: [UserDrinkEntry] = []
    /// 全量条目（含逻辑删除），供历史记录查询
    private(set) var allEntries: [UserDrinkEntry] = []

    private var storeURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("user_drinks.json")
    }

    private init() { load() }

    // MARK: - 读取

    private func load() {
        guard let data = try? Data(contentsOf: storeURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = (try? decoder.decode([UserDrinkEntry].self, from: data)) ?? []
        allEntries = decoded
        entries    = decoded.filter { !$0.isHidden }
    }

    // MARK: - 写入

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(allEntries) else { return }
        try? data.write(to: storeURL, options: .atomic)
        entries = allEntries.filter { !$0.isHidden }
    }

    // MARK: - CRUD

    func add(_ entry: UserDrinkEntry) {
        allEntries.append(entry)
        persist()
    }

    func update(_ entry: UserDrinkEntry) {
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
