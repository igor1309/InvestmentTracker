//
//  UniversalEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 13.07.2020.
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
    
    @Binding var isPresented: Bool
    @Binding var draft: T?
    
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
        self._isPresented = isPresented
        self._draft = draft
        
        self.validator = validator
        self.onDismiss = onDismiss
        self.editor = editor
        
        /// if draft is nil than it's creation of the new object, otherwise editing of the existing one
        self.title = draft.wrappedValue == nil ? "Add" : "Edit"
        
        /// if draft is nil than object is created with empty initializer init(), since it is Placeholdable it has such init
        self._version = State(initialValue: draft.wrappedValue ?? T.init())
        print("init:\n     draft: \(String(describing: draft.wrappedValue))\n     version: \(version)")
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                onDismiss()
            } content: {
                NavigationView {
                    
                    editor($version)
                        .debugPrint("editor: version: \(version)")
                        
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
