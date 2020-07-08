//
//  Create_EditorWrapperTest.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 08.07.2020.
//

import SwiftUI
import InvestmentDataModel

//  MARK: How to use EditorWrapper for Creating new entity
struct Create_EditorWrapperTest: View {
    var entity: Entity
    
    @State private var original: Entity?
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Text(original?.name ?? "")
            Text(original?.note ?? "")

            Button("Create New Entity") {
                isPresented = true
            }
            
            .sheet(isPresented: $isPresented) {
                //  onDismiss
                if original == nil {
                    print("nothing was created or edit was cancelled")
                } else {
                    print("Entity with name '\(original!.name)' was created or edited, ready to use")
                }
            } content: {
                CreatorWrapper(original: $original, isPresented: $isPresented) { draft in
                    Form {
                        TextField("Name", text: draft.name)
                        TextField("Note", text: draft.note)
                    }
                }
            }
        }
    }
}

struct Create_EditorWrapperTest_Previews: PreviewProvider {
    static let entity = Entity("Test", note: "Test Entityt")
    
    static var previews: some View {
        Create_EditorWrapperTest(entity: entity)
    }
}
