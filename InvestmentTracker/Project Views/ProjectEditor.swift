//
//  ProjectEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectEditor: View {
    @Binding var project: Project
    
    var body: some View {
        List {
            Section {
                TextField("Project Name", text: $project.name)
                TextField("Note", text: $project.note)
            }
            
            Section {
                Picker("Currency", selection: $project.currency) {
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
            ProjectEditor(project: .constant(Project()))
        }
        .preferredColorScheme(.dark)
    }
}
