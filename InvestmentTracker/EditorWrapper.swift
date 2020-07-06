//
//  EditorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI

struct EditorWrapper<T, Editor: View>: View {
    
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
                
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        isPresented = false
                    },
                    trailing: Button("Save") {
                        original = draft
                        isPresented = false
                    }
                )
        }
    }
}

struct EditorWrapperTest: View {
    @State private var text: String = "Test String"
    @State private var isPresented = false
    
    var body: some View {
        Button("Edit \(text)") {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            EditorWrapper(draft: $text, isPresented: $isPresented) { draft in
                Form {
                    TextField("Text", text: draft)
                }
                .navigationTitle("Editor")
            }
        }
    }
}

struct EditorWrapper_Previews: PreviewProvider {
    static var previews: some View {
        EditorWrapperTest()
    }
}
