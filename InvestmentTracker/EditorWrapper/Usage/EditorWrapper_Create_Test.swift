//
//  Create_EditorWrapperTest.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 08.07.2020.
//

import SwiftUI
import InvestmentDataModel

//  MARK: How to use EditorWrapper for Creating new entity
struct EditorWrapper_Create_Test: View {
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
                if let original = original {
                    print("Entity with name '\(original.name)' was created or edited, ready to use")
                } else {
                    print("nothing was created or edit was cancelled")
                }
                original = nil
            } content: {
                EditorWrapper(original: $original, isPresented: $isPresented) { draft in
                    Form {
                        TextField("Name", text: draft.name)
                        TextField("Note", text: draft.note)
                    }
                }
            }
        }
    }
}

struct EditorWrapper_Create_Test_Previews: PreviewProvider {
    static var previews: some View {
        EditorWrapper_Create_Test(entity: Entity("Test", note: "Test Entity"))
    }
}
