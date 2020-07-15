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
    
    let draft: T?
    let validator: (T) -> Bool
    let handler: (T?) -> Void
    let editor: (Binding<T>) -> Editor
    let title: String
    
    @State private var version: T
    
    init(
        _ draft: T?,
        validator: @escaping (T) -> Bool,
        handler: @escaping (T?) -> Void,
        @ViewBuilder editor: @escaping (Binding<T>) -> Editor
    ) {
        self.draft = draft
        
        self.validator = validator
        self.handler = handler
        self.editor = editor
        
        /// if draft is nil than it's creation of the new object, otherwise editing of the existing one
        self.title = draft == nil ? "Add" : "Edit"
        
        /// if draft is nil than object is created with empty initializer init(), since it is Placeholdable it has such init
        self._version = State(initialValue: draft ?? T.init())
    }
    
    var body: some View {
        NavigationView {
            
            editor($version)
                
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        handler(nil)
                    },
                    trailing: Button("Save") {
                        handler(version)
                    }
                    .disabled(!validator(version))
                )
        }
    }
}
