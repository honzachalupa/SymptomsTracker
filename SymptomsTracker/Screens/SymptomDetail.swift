import SwiftUI

extension ForEach {
    public init<T: RandomAccessCollection>(
        data: T,
        content: @escaping (T.Index, T.Element) -> Content
    ) where T.Element: Identifiable, T.Element: Hashable, Content: View, Data == [(T.Index, T.Element)], ID == T.Element  {
        self.init(Array(zip(data.indices, data)), id: \.1) { index, element in
            content(index, element)
        }
    }
}

struct SymptomDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    var symptom: Symptom
    
    @State private var isSheetShown: Bool = false
    @State private var isDeleteConfirmationShown: Bool = false
    
    private func deleteSymptom() {
        withAnimation {
            modelContext.delete(symptom)
        }
    }
    
    private func deleteEntry(_ index: Int) {
        symptom.entries!.remove(at: index)
    }
    
    var body: some View {
        VStack {
            List {
                if !symptom.entries!.isEmpty {
                    Section {
                        ChartView(symptomEntries: symptom.entries!)
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
                
                Section("Entries") {
                    if !symptom.entries!.isEmpty {
                        ForEach(data: symptom.entries!) { index, entry in
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
                                Button("Delete") {
                                    deleteEntry(index)
                                }
                                .tint(.red)
                                
                                Button("Edit") {
                                    print("Edit")
                                }
                                .tint(.green)
                            }
                        }
                    }
                    
                    Button("Add Entry") {
                        isSheetShown.toggle()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { isDeleteConfirmationShown.toggle() }, label: {
                    Label("Delete Symptom", systemImage: "trash")
                })
                .confirmationDialog(
                    "Are you sure?",
                    isPresented: $isDeleteConfirmationShown,
                    titleVisibility: .visible
                ) {
                    Button("Delete") {
                        withAnimation {
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
                // .presentationDetents([.height(200)])
                // .presentationDragIndicator(.visible)
        })
        .navigationTitle(SymptomNameWithIcon(name: symptom.name, icon: symptom.icon))
    }
}

#Preview {
    SymptomDetailScreen(symptom: symptomsMock.first!)
        .modelContainer(previewContainer)
}
