//
//  ProjectEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectEditor: View {
    @Binding var draft: Project
    
    var body: some View {
        List {
            Section {
                TextField("Project Name", text: $draft.name)
                TextField("Note", text: $draft.note)
            }
            
            Section {
                Picker("Currency", selection: $draft.currency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Text(currency.symbol).tag(currency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ProjectEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectEditor(draft: .constant(Project()))
        }
        .preferredColorScheme(.dark)
    }
}
