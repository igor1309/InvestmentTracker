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

struct EntityEditor_Previews: PreviewProvider {
    @State static var entity = Entity.kitProgressOOO
    
    static var previews: some View {
        NavigationView {
            EntityEditor(entity: $entity)
        }
        .preferredColorScheme(.dark)
    }
}
