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
    
    private let rates: [Double] = [0, 3, 6, 9, 12, 15, 18].map { $0/100 }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Discount Rate".uppercased())) {
                    Picker("Discount Rate", selection: $settings.rate) {
                        ForEach(rates, id:\.self) { rate in
                            Text("\(rate * 100, specifier: "%.f%%")").tag(rate)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(
                    header: Text("View Options")
                ) {
                    Toggle("Compact Row", isOn: $settings.compactRow)
                }
                
                #if DEBUG
                Section(
                    header: Text("Debug only")
                ) {
                    Toggle("Show UUID", isOn: $settings.showUUID)
                }
                #endif
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
            .preferredColorScheme(.dark)
            .environmentObject(Settings())
    }
}
