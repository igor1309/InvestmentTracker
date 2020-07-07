//
//  EditorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EditorWrapper<T: Validatable, Editor: View>: View {
    
    @Binding var original: T
    @Binding var isPresented: Bool
    
    let editor: (Binding<T>) -> Editor
    
    @State private var draft: T
    
    init(draft: Binding<T>,
         isPresented: Binding<Bool>,
         editor: @escaping (Binding<T>) -> Editor
    ) {
        self._original = draft
        self._isPresented = isPresented
        self._draft = State(initialValue: draft.wrappedValue)
        self.editor = editor
    }
    
    var body: some View {
        NavigationView {
            
            editor($draft)
                
                .navigationTitle("Edit")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        isPresented = false
                    },
                    trailing: Button("Save") {
                        original = draft
                        isPresented = false
                    }
                    .disabled(!draft.isValid)
                )
        }
    }
}

struct WrapperTest: View {
    var entity: Entity
    
    @State private var original: Entity?
    @State private var isPresented = false
    
    init(entity: Entity) {
        self.entity  = entity
        self._original = State(initialValue: entity)
    }
    
    var body: some View {
        VStack {
            Text(original?.name ?? "")
            Text(original?.note ?? "")
            
            Button("Edit Entity") {
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

struct EditorWrapperTest: View {
    var entity: Entity
    
    @State private var original: Entity
    @State private var isPresented = false
    
    init(entity: Entity) {
        self.entity  = entity
        self._original = State(initialValue: entity)
    }
    
    var body: some View {
        VStack {
            Text(original.name)
            Text(original.note)
            
            Button("Edit Entity") {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                EditorWrapper(draft: $original, isPresented: $isPresented) { draft in
                    Form {
                        TextField("Name", text: draft.name)
                        TextField("Note", text: draft.note)
                    }
                }
            }
        }
    }
}

struct EditorWrapper_Previews: PreviewProvider {
    static var previews: some View {
        EditorWrapperTest(entity: Entity("Some Entity", note: "some text as note here"))
    }
}
