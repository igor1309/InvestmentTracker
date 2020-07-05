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
    @Binding var shouldSave: Bool
    
    var editor: Editor
    
    init(draft: Binding<T>,
         shouldSave: Binding<Bool>,
         @ViewBuilder editor: () -> Editor
    ) {
        self._draft = draft
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
                )
        }
    }
}

