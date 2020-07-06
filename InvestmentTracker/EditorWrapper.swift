//
//  EditorWrapper.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI

struct EditorWrapper<T, Editor: View>: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var draft: T
//    @Binding var canSave: Bool
    @Binding var shouldSave: Bool
    
    let editor: Editor
    
    init(draft: Binding<T>,
//         canSave: Binding<Bool>,
         shouldSave: Binding<Bool>,
         @ViewBuilder editor: @escaping () -> Editor
    ) {
        self._draft = draft
//        self._canSave = canSave
        self._shouldSave = shouldSave
        self.editor = editor()
    }
    
    var body: some View {
        NavigationView {
            
            editor
                
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        shouldSave = false
                        presentation.wrappedValue.dismiss()
                    },
                    trailing: Button("Save") {
                        shouldSave = true
                        presentation.wrappedValue.dismiss()
                    }
//                    .disabled(!canSave)
                )
        }
    }
}

