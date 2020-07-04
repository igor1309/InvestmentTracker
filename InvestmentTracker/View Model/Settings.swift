//
//  Settings.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI

final class Settings: ObservableObject {
    @AppStorage("DiscountRate") var rate: Double = 12 / 100
}
