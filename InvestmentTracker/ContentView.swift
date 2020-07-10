//
//  ContentView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ContentView: View {
    @StateObject var portfolio: Portfolio = Portfolio()
    @StateObject var settings: Settings = Settings()
    
    var body: some View {
        ProjectList()
            .environmentObject(portfolio)
            .environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
