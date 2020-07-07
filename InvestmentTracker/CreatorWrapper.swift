//
//  CreatorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

/// This Wrapper returns nil if creation of new object or editind was cancelled,
/// or returns edited value if object was validated and 'saved' ("Save" button was pressed)
/// Return of values is done by binding
struct CreatorWrapper<T: Validatable & Placeholdable, Editor: View>: View {
    
    @Binding var original: T?
    @Binding var isPresented: Bool
    
    let editor: (Binding<T>) -> Editor
    
    @State private var draft: T
    
    let title: String
    
    init(original: Binding<T?>,
         isPresented: Binding<Bool>,
         editor: @escaping (Binding<T>) -> Editor
    ) {
        self._original = original
        self._isPresented = isPresented
        
        /// if original is nil than object is created with empty initializer (init(), since it is Placeholdable it has such init)
        self._draft = State(initialValue: original.wrappedValue == nil ? T.init() : original.wrappedValue!)
        self.editor = editor
        
        /// if original is nil than it's creation of the new object, therwise editing of the existing one
        self.title = original.wrappedValue == nil ? "Add" : "Edit"
    }
    
    var body: some View {
        NavigationView {
            
            editor($draft)
                
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        original = nil
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

struct CreatorWrapperTest: View {
    var entity: Entity
    
    @State private var original: Entity?
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Text(original?.name ?? "--")
            Button("Create New Entity") {
                isPresented = true
            }
            Button("Edit Existing") {
                original = Entity()
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
                        TextField("Text", text: draft.name)
                    }
                }
            }
        }
    }
}



struct CreatorWrapper_Previews: PreviewProvider {
    static var previews: some View {
        CreatorWrapperTest(entity: Entity())
    }
}
