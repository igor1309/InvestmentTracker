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
    
    @Binding var isPresented: Bool
    @Binding var draft: T?
    
    let validator: (T) -> Bool
    let editor: (Binding<T>) -> Editor
    let title: String
    
    @State private var version: T
    
    init(
        isPresented: Binding<Bool>,
        original: Binding<T?>,
        validator: @escaping (T) -> Bool,
        @ViewBuilder editor: @escaping (Binding<T>) -> Editor
    ) {
        self._isPresented = isPresented
        self._draft = original
        
        self.validator = validator
        self.editor = editor
        
        /// if draft is nil than it's creation of the new object, otherwise editing of the existing one
        self.title = original.wrappedValue == nil ? "Add" : "Edit"
        
        /// if draft is nil than object is created with empty initializer init(), since it is Placeholdable it has such init
        self._version = State(initialValue: original.wrappedValue ?? T.init())
    }
    
    var body: some View {
        NavigationView {
            
            editor($version)
                
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        draft = nil
                        isPresented = false
                    },
                    trailing: Button("Save") {
                        draft = version
                        isPresented = false
                    }
                    .disabled(!validator(version))
                )
        }
    }
}
