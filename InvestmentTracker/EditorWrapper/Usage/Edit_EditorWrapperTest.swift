//
//  Edit_EditorWrapperTest.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 08.07.2020.
//

import SwiftUI
import InvestmentDataModel

//  MARK: How to use EditorWrapper for Editing
struct Edit_EditorWrapperTest: View {
    var entity: Entity
    
    @State private var original: Entity?
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Text(entity.name)
            Text(entity.note)
            
            Divider()
            
            Button("Edit Entity") {
                print("original: \(String(describing: original))")
                original = entity
                print("original: \(String(describing: original))")
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                //  onDismiss
                if original == nil {
                    print("nothing was created or edit was cancelled")
                } else {
                    print("Entity with name '\(original!.name)' was created or edited, ready to use")
                    original = nil
                }
            } content: {
                EditorWrapper(
                    original: $original,
                    isPresented: $isPresented
                ) { draft in
                    Form {
                        TextField("Name", text: draft.name)
                        TextField("Note", text: draft.note)
                    }
                }
            }
        }
    }
}

struct Edit_EditorWrapperTest_Previews: PreviewProvider {
    static var previews: some View {
        Edit_EditorWrapperTest(entity: Entity("Test", note: "Test Entity"))
    }
}
