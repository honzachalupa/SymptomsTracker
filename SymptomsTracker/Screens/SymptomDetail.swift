import SwiftUI

struct SymptomDetailScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let healthKit = HealthKitManager()
    
    var symptom: Symptom
    
    @State private var dataStore = DataStoreManager()
    @State private var isSheetShown: Bool = false
    @State private var isDeleteConfirmationShown: Bool = false
    
    private func deleteSymptom() {
        withAnimation {
            dataStore.delete(symptom)
        }
    }
    
    private func deleteEntry(_ entry: Entry) {
       if let healthKitType = symptom.healthKitType {
            healthKit.delete(entry.id, healthKitType.key)
        }
        
        symptom.entries!.remove(at: symptom.entries!.firstIndex(of: entry)!)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HealthKitConnectionLabel(symptom: symptom)
                .padding(.leading, 25)
            
            ZStack {
                List {
                    if !symptom.entries!.isEmpty {
                        Section {
                            EntriesChartView(symptomEntries: symptom.entries!)
                                .aspectRatio(1.5, contentMode: .fit)
                        }
                    }
                    
                    if let note = symptom.note {
                        if !note.isEmpty {
                            Section("Note") {
                                Text(note)
                            }
                        }
                    }
                    
                    if symptom.entries!.isEmpty {
                        Text("Add your first entry.")
                    } else {
                        Section("Entries") {
                            ForEach(symptom.entries!, id: \.id) { entry in
                                VStack {
                                    HStack {
                                        Text(entry.date, formatter: dateFormatter)
                                        
                                        Spacer()
                                        
                                        Text(getSeverityLabel(entry.severity))
                                    }
                                    
                                    if entry.triggers!.count > 0 {
                                        VStack(alignment: .leading) {
                                            Text("Triggers")
                                                .textCase(.uppercase)
                                                .font(.footnote)
                                                .opacity(0.5)
                                                .padding(.bottom, 2)
                                            
                                            HStack {
                                                ForEach(entry.triggers!, id: \.self) { trigger in
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
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        deleteEntry(entry)
                                    }
                                    
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
                    dataStore.refreshData()
                }
                
                GeometryReader { screen in
                    Button(action: {
                        isSheetShown.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                            .padding(30)
                            .background(
                                Circle()
                                    .frame(width: 50, height: 50)
                            )
                    })
                    .position(
                        x: screen.size.width - 40,
                        y: screen.size.height - 20
                    )
                }
            }
        }
        .toolbar {
            if symptom.healthKitType == nil {
                ToolbarItem {
                    NavigationLink {
                        SymptomEditScreen(symptom: symptom)
                    } label: {
                        Label("Edit Symptom", systemImage: "pencil")
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
                        withAnimation {
                            dismiss()
                            deleteSymptom()
                        }
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
        })
        .navigationTitle(SymptomNameWithIcon(name: symptom.name, icon: symptom.icon))
    }
}

#Preview {
    NavigationStack {
        SymptomDetailScreen(symptom: symptomsMock.first!)
            // .modelContainer(previewContainer)
    }
}
