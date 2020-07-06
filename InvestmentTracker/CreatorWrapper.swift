//
//  CreatorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct CreatorWrapper<T: Validatable & Placeholdable, Editor: View>: View {
    
    @Binding var original: T?
    @Binding var isPresented: Bool
    
    let editor: (Binding<T>) -> Editor
    
    @State private var draft: T
    
    init(draft: Binding<T?>,
         isPresented: Binding<Bool>,
         editor: @escaping (Binding<T>) -> Editor
    ) {
        self._original = draft
        self._isPresented = isPresented
        self._draft = State(initialValue: draft.wrappedValue == nil ? T.init() : draft.wrappedValue!)
        self.editor = editor
    }
    
    var body: some View {
        NavigationView {
            
            editor($draft)
                
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
    @State private var original: Entity? = nil
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Text(original?.name ?? "--")
            Button("Create New Entity") {
                original = Entity()
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                if original == nil {
                    print("nothing was created")
                } else {
                    print("Entity with name '\(original!.name)' was created")
                }
            } content: {
                CreatorWrapper(draft: $original, isPresented: $isPresented) { draft in
                    Form {
                        TextField("Text", text: draft.name)
                    }
                    .navigationTitle("Add")
                }
        }
        }
    }
}



struct CreatorWrapper_Previews: PreviewProvider {
    static var previews: some View {
        CreatorWrapperTest()
    }
}
