//
//  AddProject.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct AddProject: View {
    @Binding var draft: Project
    
    @Binding var isPresented: Bool
    @Binding var shouldSave: Bool

    @State private var shouldSaveEntity = false
    
    @State private var showEntityEditor = false
    @State private var showEntityListEditor = false
    
    @State private var newEntity = Entity()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Project Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                }
                
                Section(header: Text("Entities".uppercased())) {
                    if !draft.entities.isEmpty {
                        Button {
                            prepareEntityListEditor()
                        } label: {
                            Text(draft.entities.map { $0.name }.joined(separator: "; "))
                        }
                        .sheet(isPresented: $showEntityListEditor) {
                            handleEntityListEditor()    //  onDismiss
                        } content: {
                            EntityListEditor(project: $draft)
                        }
                    }
                    
                    Button {
                        prepareNewEntity()
                    } label: {
                        Text("TBD: New Entity")
                    }
                    .sheet(isPresented: $showEntityEditor) {
                        handleEntityEditor()    //  onDismiss
                    } content: {
                        EntityEditor(entity: $newEntity, shouldSave: $shouldSaveEntity)
                    }
                }
            }
            .navigationTitle("Add Project")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    shouldSave = false
                    isPresented = false
//                    presentation.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    shouldSave = true
                    isPresented = false
//                    presentation.wrappedValue.dismiss()
                }
                .disabled(!draft.isValid)
            )
        }
    }
    
    private func handleEntityListEditor() {
        //  MARK: FINISH THIS
        print("saving...")
        
        shouldSave = false
    }
    
    private func prepareEntityListEditor() {
        //  MARK: FINISH THIS
        //  open entities editor
        //  MARK: do not delete entities used in payments!!
        
        showEntityListEditor = true
    }
    
    
    private func handleEntityEditor() {
        if shouldSaveEntity {
            //  MARK: FINISH THIS
            print("saving...")
            
            let generator = UINotificationFeedbackGenerator()
            withAnimation {
                if draft.addEntity(newEntity) {
                    print("project added ok")
                    generator.notificationOccurred(.success)
                } else {
                    print("error adding project")
                    generator.notificationOccurred(.error)
                }
            }
            shouldSaveEntity = false
        }
    }
    
    private func prepareNewEntity() {
        //  MARK: FINISH THIS
        newEntity = Entity()
        showEntityEditor = true
    }
    

}

struct AddProject_Previews: PreviewProvider {
    @State static var project = Project()
    @State static var isPresented = false
    @State static var shouldSave = false
    
    static var previews: some View {
        AddProject(draft: $project, isPresented: $isPresented, shouldSave: $shouldSave)
    }
}
