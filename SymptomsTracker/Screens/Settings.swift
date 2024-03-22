import SwiftUI

struct SettingsScreen: View {
    @State private var dataStore = DataStoreManager()
    @State private var isDeleteConfirmationShown: Bool = false
    
    private func flushData() {
        /* TODO: dataStore.deleteAll
         
         do {
            try modelContext.delete(model: Symptom.self)
            try modelContext.delete(model: Entry.self)
            try modelContext.delete(model: Trigger.self)
        } catch {
            print("Failed to clear all Country and City data.")
        } */
    }
    
    var body: some View {
        List {
            Button(role: .destructive, action: { isDeleteConfirmationShown.toggle() }, label: {
                Text("Delete all data")
            })
            .confirmationDialog(
                "Are you sure you want to delete all data?",
                isPresented: $isDeleteConfirmationShown,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        flushData()
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
        // .modelContainer(previewContainer)
}
