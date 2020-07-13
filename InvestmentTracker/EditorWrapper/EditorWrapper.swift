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
/// Validation function prevents saving non-valid drafts
/// Return of values is done by binding
struct EditorWrapper<T: Placeholdable, Editor: View>: View {
    
    @Binding var original: T?
    @Binding var isPresented: Bool
    
    let validator: (T) -> Bool
    let editor: (Binding<T>) -> Editor
    let title: String
    
    @State private var draft: T
        
    init(original: Binding<T?>,
         isPresented: Binding<Bool>,
         validator: @escaping (T) -> Bool,
         @ViewBuilder editor: @escaping (Binding<T>) -> Editor
    ) {
        self._original = original
        self._isPresented = isPresented
        
        /// if original is nil than object is created with empty initializer init(), since it is Placeholdable it has such init
        self._draft = State(initialValue: original.wrappedValue ?? T.init())
        
        self.validator = validator
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
                    .disabled(!validator(draft))
                )
        }
    }
}
