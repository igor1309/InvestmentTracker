//
//  Edit_EditorWrapperTest.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 08.07.2020.
//

import SwiftUI
import InvestmentDataModel

enum EditorAction { case save, cancel }
enum EditorResult<Value> {
    case value(Value)
    case action(EditorAction)
}



//  MARK: How to use EditorWrapper for Editing
struct Edit_EditorWrapperTest: View {
    var entity: Entity
    
    @State private var original: EditorResult = .value(Entity())
    @State private var isPresented = false
    
    init(entity: Entity) {
        self.entity = entity
        _original = State(initialValue: .value(entity))
    }
    
    var body: some View {
        VStack {
            Text(entity.name)
            Text(entity.note)
            
            Divider()
            
            Button("Edit Entity") {
                print("original: \(String(describing: original))")
                original = .value(entity)
                print("original: \(String(describing: original))")
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                //  onDismiss
                switch original {
                case .action(_):
                    print("nothing was created or edit was cancelled")
                case .value(let original):
                    print("Entity with name '\(original.name)' was created or edited, ready to use")
//                    original = nil
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
