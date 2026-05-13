import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var repo = DrinkRepository.shared

    var body: some View {
        TabView {
            DrinkTabView()
                .tabItem {
                    Label("喝一杯", systemImage: "cup.and.saucer.fill")
                }

            LibraryTabView()
                .tabItem {
                    Label("饮品库", systemImage: "books.vertical.fill")
                }

            HistoryTabView()
                .tabItem {
                    Label("历史", systemImage: "calendar")
                }

            ProfileTabView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
        }
        .tint(Color.sbGreenDeep)
        .environmentObject(repo)
    }
}

#Preview {
    RootView()
        .modelContainer(for: CupRecord.self, inMemory: true)
}
