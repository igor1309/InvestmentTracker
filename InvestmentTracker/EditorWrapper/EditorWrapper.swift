//
//  EditorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

//extension View {
//    func sheetEditor<T: Placeholdable, Editor: View>(
//        isPresented: Binding<Bool>,
//        draft: Binding<T?>,
//        validator: @escaping (T) -> Bool,
//        onDismiss: @escaping () -> Void,
//        @ViewBuilder editor: @escaping (Binding<T>) -> Editor
//    ) -> some View {
//        self.modifier(
//            UniversalEditor(
//                isPresented: isPresented,
//                draft: draft,
//                validator: validator,
//                onDismiss: onDismiss,
//                editor: editor
//            )
//        )
//    }
//}

struct UniversalEditor<T: Placeholdable, Editor: View>: ViewModifier {
    
    @Binding var draft: T?
    @Binding var isPresented: Bool
    
    let validator: (T) -> Bool
    let onDismiss: () -> Void
    let editor: (Binding<T>) -> Editor
    let title: String
    
    @State private var version: T
    
    init(
        isPresented: Binding<Bool>,
        draft: Binding<T?>,
        validator: @escaping (T) -> Bool,
        onDismiss: @escaping () -> Void,
        @ViewBuilder editor: @escaping (Binding<T>) -> Editor
    ) {
        self._draft = draft
        
        print("init draft:\(String(describing: draft.wrappedValue))")
        
        self._isPresented = isPresented
        
        /// if original is nil than object is created with empty initializer init(), since it is Placeholdable it has such init
        self._version = State(initialValue: draft.wrappedValue ?? T.init())
        
        self.validator = validator
        self.onDismiss = onDismiss
        self.editor = editor
        
        /// if original is nil than it's creation of the new object, therwise editing of the existing one
        self.title = draft.wrappedValue == nil ? "Add" : "Edit"
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                onDismiss()
            } content: {
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
}

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
    
    init(
        original: Binding<T?>,
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
