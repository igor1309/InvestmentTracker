//
//  EditorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

/// This Wrapper returns nil if creation of new object or editind was cancelled,
/// or returns edited value if object was validated and 'saved' ("Save" button was pressed)
/// Return of values is done by binding
struct EditorWrapper<T: Validatable & Placeholdable, Editor: View>: View {
    
    @Binding var original: EditorResult<T>
    @Binding var isPresented: Bool
    
    let editor: (Binding<T>) -> Editor
    
    @State private var draft: T
    
    let title: String = "Editor"
    
    init(original: Binding<EditorResult<T>>,
         isPresented: Binding<Bool>,
         @ViewBuilder editor: @escaping (Binding<T>) -> Editor
    ) {
        print("init: original.wrappedValue: \(String(describing: original.wrappedValue))")
        
        self._original = original
        self._isPresented = isPresented
        
        /// if original is nil than object is created with empty initializer (init(), since it is Placeholdable it has such init)
        switch original.wrappedValue {
        case .value(let original):
            print("got value")
            self._draft = State(initialValue: original)
        case .action(_):
            print("got action")
            self._draft = State(initialValue: T.init())
        }
        self.editor = editor
        
        /// if original is nil than it's creation of the new object, therwise editing of the existing one
//        self.title = original.wrappedValue == nil ? "Add" : "Edit"
    }
    
    var body: some View {
        NavigationView {
            
            editor($draft)
                
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        original = .action(.cancel)
                        isPresented = false
                    },
                    trailing: Button("Save") {
                        original = .value(draft)
                        isPresented = false
                    }
//                    .disabled(!draft.isValid)
                )
        }
    }
}
