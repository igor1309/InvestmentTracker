//
//  EditorWrapperTest_Edit.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 08.07.2020.
//

import SwiftUI
import InvestmentDataModel

//  MARK: How to use EditorWrapper for Editing
struct EditorWrapper_Edit: View {
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
        _original = State(initialValue: entity)
    }
    
    @State private var original: Entity?
    
    @State private var showEditor = false
    
    var body: some View {
        VStack {
            Text(entity.name)
            Text(entity.note)
            
            Divider()
            
            Button("Edit Entity") {
                print("original: \(String(describing: original))")
                original = entity
                print("original: \(String(describing: original))")
                showEditor = true
            }
            .sheet(isPresented: $showEditor) {
                //  onDismiss
                if let original = original {
                    print("Entity with name '\(original.name)' was created or edited, ready to use")
                } else {
                    print("nothing was created or edit was cancelled")
                }
                original = entity
            } content: {
                EditorWrapper(
                    isPresented: $showEditor,
                    original: $original
                ) { draft in
                    draft.isValid
                } editor: { draft in
                    Form {
                        TextField("Name", text: draft.name)
                        TextField("Note", text: draft.note)
                    }
                }
            }
        }
    }
}

struct EditorWrapper_Edit_Test: View {
    var entity = Entity("Test", note: "Test Entity")
    
    var body: some View {
        EditorWrapper_Edit(entity: entity)
    }
}

struct EditorWrapper_Edit_Test_Previews: PreviewProvider {
    static var previews: some View {
        EditorWrapper_Edit_Test()
    }
}
