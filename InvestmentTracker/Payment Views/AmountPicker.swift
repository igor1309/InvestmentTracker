//
//  AmountPicker.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import SwiftUI

struct AmountPicker: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var amount: Double
    
    let amounts: [Double] = [10_000, 100_000, 500_000, 1_000_000, 2_000_000, 3_000_000, 5_000_000, 10_000_000]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(amounts, id: \.self) { amount in
                    HStack {
                        Spacer()
                        Text("\(amount, specifier: "%.f")").tag(amount)
                            .foregroundColor(color(for: amount))
                    }
                    .onTapGesture {
                        self.amount = amount
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Amount")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func color(for amount: Double) -> Color {
        self.amount == amount ? Color(UIColor.systemOrange) : .primary
    }
}


struct AmountPicker_Previews: PreviewProvider {
    @State static var amount: Double = 1_000_000
    
    static var previews: some View {
        AmountPicker(amount: $amount)
            .preferredColorScheme(.dark)
    }
}
