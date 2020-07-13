//
//  Settings.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI

final class Settings: ObservableObject {
    @Published var rate: Double = UserDefaults.standard.double(forKey: "DiscountRate") {
        didSet {
            UserDefaults.standard.setValue(rate, forKey: "DiscountRate")
        }
    }
    
    @AppStorage("CompactRow") var compactRow: Bool = true
    
    @Published var showUUID: Bool  = UserDefaults.standard.bool(forKey: "ShowUUID") {
        didSet {
            UserDefaults.standard.setValue(showUUID, forKey: "ShowUUID")
        }
    }
}
