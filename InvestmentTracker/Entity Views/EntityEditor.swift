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
    let project: Project
    
    var body: some View {
        List {
            TextField("Entity Name", text: $entity.name)
            TextField("Note", text: $entity.note)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit Entity")
    }
}

struct EntityEditor_Previews: PreviewProvider {
    @State static var entity: Entity? = Entity.kitProgressOOO
    
    static let project = Project.natachtari
    
    static var previews: some View {
        NavigationView {
            EditorWrapper(
                isPresented: .constant(true),
                original: $entity
            ) { entity in
                entity.isValid
            } editor: { entity in
                EntityEditor(entity: entity, project: project)
            }
        }
        .preferredColorScheme(.dark)
    }
}
