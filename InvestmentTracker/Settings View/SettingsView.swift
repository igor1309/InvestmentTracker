//
//  SettingsView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var settings: Settings
    
    private func formatter() -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        return formatter
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Discount Rate".uppercased())) {
                    TextField("Rate", value: $settings.rate, formatter: formatter())
                        .keyboardType(.decimalPad)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button("Done") {
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
    }
}
