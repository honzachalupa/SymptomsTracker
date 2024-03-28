import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var dataStore: DataStoreManager
    @State private var isDeleteConfirmationShown: Bool = false
    
    var body: some View {
        List {
            Button("Delete all data", role: .destructive) {
                isDeleteConfirmationShown.toggle()
            }
            .confirmationDialog(
                "Are you sure you want to delete all data?",
                isPresented: $isDeleteConfirmationShown,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        dataStore.deleteAll()
                    }
                }
                .keyboardShortcut(.defaultAction)
                
                Button("No", role: .cancel) {}
            }
        }
    }
}

#Preview {
    SettingsScreen()
}
