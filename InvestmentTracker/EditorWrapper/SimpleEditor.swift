//
//  SimpleEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct SimpleEditor: View {
    var title: String
    var nameTitle: String = "Name"
    var noteTitle: String = "Note"

    @Binding var name: String
    @Binding var note: String
    
    var body: some View {
        Form {
            Section {
                TextField(nameTitle, text: $name)
                TextField(noteTitle, text: $note)
            }
        }
        .navigationTitle(title)
    }
}

struct SimpleEditor_Previews: PreviewProvider {
    static var previews: some View {
        SimpleEditor(title: "Edit", name: .constant("Name"), note: .constant("Note"))
    }
}
