//
//  EntityEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EntityEditor: View {
    
    @Binding var entity: Entity
    
    var body: some View {
        Form {
            TextField("Entity Name", text: $entity.name)
            TextField("Note", text: $entity.note)
        }
        .navigationTitle("Edit Entity")
    }
}

struct EntityEditor1: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var entity: Entity
    @Binding var shouldSave: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Entity Name", text: $entity.name)
                TextField("Note", text: $entity.note)
            }
            .navigationTitle("Edit Entity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    shouldSave = false
                    presentation.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    shouldSave = true
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct EntityEditor_Previews: PreviewProvider {
    static var previews: some View {
        EntityEditor(entity: .constant(Entity.kitProgressOOO))
            .preferredColorScheme(.dark)
    }
}
