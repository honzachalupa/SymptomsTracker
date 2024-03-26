import SwiftUI

struct SymptomDetailScreen: View {
    var symptom: Symptom
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStoreManager
    @State private var entriesSorted: [Entry] = []
    @State private var isSheetShown: Bool = false
    @State private var isDeleteConfirmationShown: Bool = false
    
    func deleteEntry(_ entry: Entry) {
        Task {
            await dataStore.delete(entry, refSymptom: symptom)
        }
    }
    
    func deleteSymptom() {
        Task {
            await dataStore.delete(symptom)
            dismiss()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HealthKitConnectionLabel(symptom: symptom)
                .padding(.leading, 25)
            
            ZStack {
                List {
                    Section {
                        EntriesChartView(symptomEntries: entriesSorted)
                    }
                    
                    if let note = symptom.note, !note.isEmpty {
                        Section("Note") {
                            Text(note)
                        }
                    }
                    
                    if entriesSorted.isEmpty {
                        Text("Add your first entry.")
                    } else {
                        Section("Entries") {
                            ForEach(entriesSorted, id: \.id) { entry in
                                VStack {
                                    HStack {
                                        Text(entry.date, formatter: dateFormatter)
                                        
                                        Spacer()
                                        
                                        Text(getSeverityLabel(entry.severity))
                                            .foregroundStyle(getSeverityColor(entry.severity))
                                    }
                                    
                                    if let triggers = entry.triggers {
                                        if triggers.count > 0 {
                                            VStack(alignment: .leading) {
                                                Text("Triggers")
                                                    .textCase(.uppercase)
                                                    .font(.footnote)
                                                    .opacity(0.5)
                                                    .padding(.bottom, 2)
                                                
                                                HStack {
                                                    ForEach(triggers, id: \.self) { trigger in
                                                        SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
                                                            .padding(.trailing, 10)
                                                    }
                                                    
                                                    Spacer()
                                                }
                                            }
                                            
                                            .padding()
                                            .background(.gray.opacity(0.1))
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                .swipeActions {
                                    Button("Delete") {
                                        deleteEntry(entry)
                                    }
                                    .tint(.red)
                                    
                                    NavigationLink {
                                        EntryEditScreen(entry: entry)
                                    } label: {
                                        Text("Edit")
                                    }
                                    .tint(.gray)
                                }
                            }
                        }
                    }
                    
                    if symptom.healthKitType != nil {
                        Section {
                            Button(action: openAppleHealth, label: {
                                Text("Open Health app")
                            })
                        }
                    }
                }
                .refreshable {
                    Task {
                        await dataStore.refreshData()
                    }
                }
                
                if !isSheetShown {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                isSheetShown.toggle()
                            } label: {
                                Label("Add entry", systemImage: "plus")
                                    .padding()
                                    .background(.blue.opacity(0.8))
                                    .foregroundColor(.white)
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(20)
                        }
                    }
                }
            }
        }
        .toolbar {
            if symptom.healthKitType == nil {
                ToolbarItem {
                    NavigationLink {
                        SymptomEditScreen(symptom: symptom)
                    } label: {
                        Label("Edit symptom", systemImage: "pencil")
                    }
                    
                }
            }
            
            ToolbarItem {
                Button(role: .destructive, action: { isDeleteConfirmationShown.toggle() }, label: {
                    Label("Delete Symptom", systemImage: "trash")
                })
                .confirmationDialog(
                    "Are you sure you want to delete the symptom \(symptom.name)?",
                    isPresented: $isDeleteConfirmationShown,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        deleteSymptom()
                    }
                    .keyboardShortcut(.defaultAction)
                    
                    Button("No", role: .cancel) {}
                }
            }
        }
        .sheet(isPresented: $isSheetShown, content: {
            EntryCreateScreen(symptom: symptom)
                .presentationDetents([.height(500)])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
        })
        .navigationTitle(SymptomNameWithIcon(name: symptom.name, icon: symptom.icon))
        .onAppear() {
            if let entries = symptom.entries {
                entriesSorted = entries.sorted(by: { $0.date > $1.date })
            }
        }
    }
}

#Preview {
    NavigationStack {
        SymptomDetailScreen(symptom: symptomsMock.first!)
            // .modelContainer(previewContainer)
    }
}
