import SwiftUI
import PhotosUI

/// 新增或编辑饮品类型的表单页
struct DrinkEditView: View {
    enum Mode {
        case create(brand: BrandType)
        case edit(Drink)
    }

    let mode: Mode

    @Environment(\.dismiss) private var dismiss

    // MARK: - 表单状态

    @State private var selectedBrand: BrandType
    @State private var selectedCategoryRaw: String
    @State private var isCustomCategory: Bool
    @State private var customCategoryText: String
    @State private var nameCN: String
    @State private var nameEN: String
    @State private var descriptionText: String

    // 照片相关
    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var rawPickedImage: UIImage? = nil
    @State private var croppedImage: UIImage? = nil
    @State private var showCropView = false
    @State private var photoScale: Double = 1.0
    @State private var photoAngle: Double = 0.0

    // 交互状态
    @State private var showDeleteConfirm = false
    @State private var categoryExpanded = false

    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .create(let brand):
            _selectedBrand        = State(initialValue: brand)
            // categories(for:) 对每个品牌必然非空，可安全强解
            let firstCat          = DrinkCategory.categories(for: brand).first!
            _selectedCategoryRaw  = State(initialValue: firstCat.rawValue)
            _isCustomCategory     = State(initialValue: false)
            _customCategoryText   = State(initialValue: "")
            _nameCN               = State(initialValue: "")
            _nameEN               = State(initialValue: "")
            _descriptionText      = State(initialValue: "")

        case .edit(let drink):
            _selectedBrand        = State(initialValue: drink.brand)
            // 判断是否自定义品类
            if let custom = drink.customCategoryName {
                _selectedCategoryRaw = State(initialValue: "新建系列...")
                _isCustomCategory    = State(initialValue: true)
                _customCategoryText  = State(initialValue: custom)
            } else {
                _selectedCategoryRaw = State(initialValue: drink.category.rawValue)
                _isCustomCategory    = State(initialValue: false)
                _customCategoryText  = State(initialValue: "")
            }
            _nameCN          = State(initialValue: drink.nameCN)
            _nameEN          = State(initialValue: drink.nameEN)
            _descriptionText = State(initialValue: drink.description)
        }
    }

    // MARK: - 计算属性

    private var isEditMode: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var existingEntryID: String? {
        if case .edit(let drink) = mode { return drink.id }
        return nil
    }

    private var canSave: Bool {
        let name = nameCN.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return false }
        if selectedCategoryRaw == "新建系列..." {
            let custom = customCategoryText.trimmingCharacters(in: .whitespaces)
            return !custom.isEmpty && custom.count <= 10
        }
        return true
    }

    private var categoryOptions: [String] {
        DrinkCategory.categories(for: selectedBrand).map { $0.rawValue } + ["新建系列..."]
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sbCanvas.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        brandSection
                        categorySection
                        nameSection
                        descriptionSection
                        photoSection
                        // 底部保存按钮
                        PrimaryButton(title: "保存饮品", disabled: !canSave) { save() }
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle(isEditMode ? "编辑饮品" : "新增饮品")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(Color.sbInk1)
                }
                if isEditMode {
                    // 编辑模式下，右上角显示红色胶囊删除按钮
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showDeleteConfirm = true
                        } label: {
                            Text("删除")
                                .font(.sbCaption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .confirmationDialog("删除饮品", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("确认删除", role: .destructive) {
                    if let id = existingEntryID {
                        UserDrinkStore.shared.hide(id: id)
                        DrinkRepository.shared.reloadUserDrinks()
                    }
                    dismiss()
                }
                Button("取消", role: .cancel) {}
            } message: {
                Text("删除后不影响历史记录，仅从饮品库中移除")
            }
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    guard let item = newItem,
                          let data = try? await item.loadTransferable(type: Data.self),
                          let img = UIImage(data: data) else { return }
                    rawPickedImage = img
                    showCropView = true
                }
            }
            .sheet(isPresented: $showCropView) {
                if let img = rawPickedImage {
                    ImageCropView(image: img, initialScale: photoScale, initialAngle: photoAngle) { cropped, sc, ang in
                        croppedImage = cropped
                        photoScale   = sc
                        photoAngle   = ang
                    }
                }
            }
            .onAppear { loadExistingPhoto() }
        }
    }

    // MARK: - 表单各节

    private var brandSection: some View {
        DCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("饮品品牌")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                HStack(spacing: 8) {
                    ForEach(BrandType.allCases, id: \.self) { b in
                        Button {
                            if !isEditMode {
                                selectedBrand       = b
                                selectedCategoryRaw = DrinkCategory.categories(for: b).first?.rawValue ?? ""
                                isCustomCategory    = false
                                customCategoryText  = ""
                            }
                        } label: {
                            Text(b.displayName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(selectedBrand == b ? .white : Color.sbInk1)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                                .background(selectedBrand == b ? b.brandColors.dark : Color.sbLine.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .disabled(isEditMode)
                        .opacity(isEditMode ? 0.5 : 1.0)
                    }
                }
            }
        }
    }

    private var categorySection: some View {
        DCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("饮品系列")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    Spacer()
                    Button(categoryExpanded ? "收起" : "展开") {
                        withAnimation { categoryExpanded.toggle() }
                    }
                    .font(.sbCaption)
                    .foregroundStyle(Color.sbInk2)
                }

                // 当前选中系列展示
                Text(selectedCategoryRaw == "新建系列..." ? (customCategoryText.isEmpty ? "新建系列..." : customCategoryText) : selectedCategoryRaw)
                    .font(.sbBodyS)
                    .foregroundStyle(Color.sbGreenDeep)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.sbGreenPale)
                    .clipShape(Capsule())

                if categoryExpanded {
                    // 系列选项列表
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(categoryOptions, id: \.self) { option in
                            Button {
                                selectedCategoryRaw = option
                                isCustomCategory    = option == "新建系列..."
                                if option != "新建系列..." { customCategoryText = "" }
                            } label: {
                                Text(option)
                                    .font(.sbCaption)
                                    .foregroundStyle(selectedCategoryRaw == option ? .white : Color.sbInk1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 7)
                                    .background(selectedCategoryRaw == option ? Color.sbGreenDeep : Color.sbLine.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .lineLimit(1)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // 自定义系列名称输入框
                    if isCustomCategory {
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("输入系列名称（不超过10个汉字）", text: $customCategoryText)
                                .font(.sbBodyS)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.sbCream)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.sbLine2, lineWidth: 1))
                                .onChange(of: customCategoryText) { _, val in
                                    // 限制最多10个字符（按字数计，中英文均算1个）
                                    if val.count > 10 {
                                        customCategoryText = String(val.prefix(10))
                                    }
                                }
                            Text("\(customCategoryText.count)/10")
                                .font(.sbLabel)
                                .foregroundStyle(customCategoryText.count >= 10 ? Color.sbRose : Color.sbInk3)
                        }
                    }
                }
            }
        }
    }

    private var nameSection: some View {
        DCard {
            VStack(alignment: .leading, spacing: 12) {
                // 中文名
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 2) {
                        Text("中文名")
                            .font(.sbBodyMB)
                            .foregroundStyle(Color.sbInk)
                        Text("*")
                            .font(.sbBodyMB)
                            .foregroundStyle(Color.sbRose)
                    }
                    TextField("请输入饮品中文名称", text: $nameCN)
                        .font(.sbBodyM)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.sbCream)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.sbLine2, lineWidth: 1))
                }

                Divider()

                // 英文名
                VStack(alignment: .leading, spacing: 6) {
                    Text("英文名（选填）")
                        .font(.sbBodyMB)
                        .foregroundStyle(Color.sbInk)
                    TextField("请输入饮品英文名称", text: $nameEN)
                        .font(.sbBodyM)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.sbCream)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.sbLine2, lineWidth: 1))
                }
            }
        }
    }

    private var descriptionSection: some View {
        DCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("饮品介绍（选填）")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)
                TextEditor(text: $descriptionText)
                    .font(.sbBodyS)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color.sbCream)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.sbLine2, lineWidth: 1))
            }
        }
    }

    private var photoSection: some View {
        DCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("饮品图片（选填）")
                    .font(.sbBodyMB)
                    .foregroundStyle(Color.sbInk)

                HStack(spacing: 16) {
                    // 预览圆形
                    ZStack {
                        Circle()
                            .fill(Color.sbGreenTint)
                            .frame(width: 72, height: 72)
                        if let img = croppedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 72, height: 72)
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.sbInk3)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            Text(croppedImage == nil ? "从相册选取" : "重新选取")
                                .font(.sbBodyS)
                                .foregroundStyle(Color.sbGreenDeep)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color.sbGreenPale)
                                .clipShape(Capsule())
                        }

                        if croppedImage != nil {
                            Button {
                                // 重新进入裁剪界面（用已有图片）
                                if let img = rawPickedImage {
                                    showCropView = true
                                    _ = img
                                }
                            } label: {
                                Text("重新裁剪")
                                    .font(.sbBodyS)
                                    .foregroundStyle(Color.sbInk2)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(Color.sbLine.opacity(0.5))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()
                }

                Text("选取后需在裁剪界面调整为正方形")
                    .font(.sbLabel)
                    .foregroundStyle(Color.sbInk3)
            }
        }
    }

    // MARK: - 逻辑

    /// 编辑模式下，加载已有的照片
    private func loadExistingPhoto() {
        guard case .edit(let drink) = mode,
              let fileName = drink.userPhotoFileName else { return }
        croppedImage = UserDrinkStore.shared.loadPhoto(fileName: fileName)
        if let entry = UserDrinkStore.shared.allEntries.first(where: { $0.id == drink.id }) {
            photoScale = entry.photoScale
            photoAngle = entry.photoAngle
        }
    }

    private func save() {
        let finalCatName: String
        if selectedCategoryRaw == "新建系列..." {
            finalCatName = customCategoryText.trimmingCharacters(in: .whitespaces)
        } else {
            finalCatName = selectedCategoryRaw
        }

        switch mode {
        case .create:
            // 先构建 entry，拿到固定 id，再用这个 id 存照片
            var entry = UserDrinkEntry(
                brandRaw:         selectedBrand.rawValue,
                nameCN:           nameCN.trimmingCharacters(in: .whitespaces),
                nameEN:           nameEN,
                categoryName:     finalCatName,
                drinkDescription: descriptionText
            )
            if let img = croppedImage, let jpegData = img.jpegData(compressionQuality: 0.85) {
                entry.photoFileName = UserDrinkStore.shared.savePhoto(data: jpegData, entryID: entry.id)
            }
            entry.photoScale = photoScale
            entry.photoAngle = photoAngle
            UserDrinkStore.shared.add(entry)

        case .edit(let drink):
            guard var entry = UserDrinkStore.shared.allEntries.first(where: { $0.id == drink.id }) else { return }
            entry.nameCN           = nameCN.trimmingCharacters(in: .whitespaces)
            entry.nameEN           = nameEN
            entry.categoryName     = finalCatName
            entry.drinkDescription = descriptionText
            if let img = croppedImage, let jpegData = img.jpegData(compressionQuality: 0.85) {
                entry.photoFileName = UserDrinkStore.shared.savePhoto(data: jpegData, entryID: entry.id)
            }
            entry.photoScale = photoScale
            entry.photoAngle = photoAngle
            UserDrinkStore.shared.update(entry)
        }

        DrinkRepository.shared.reloadUserDrinks()
        dismiss()
    }
}

#Preview("新增饮品") {
    DrinkEditView(mode: .create(brand: .starbucks))
}

#Preview("新增 Manner 饮品") {
    DrinkEditView(mode: .create(brand: .manner))
}

#Preview("编辑用户饮品") {
    let drink = Drink(
        id: "usr_preview",
        brand: .starbucks,
        nameCN: "定制拿铁",
        nameEN: "Custom Latte",
        category: .sbClassicCoffee,
        description: "我的专属定制饮品",
        sizes: ["grande": 38],
        photoAvatar: "",
        tags: [.hot],
        isUserCreated: true
    )
    return DrinkEditView(mode: .edit(drink))
}
