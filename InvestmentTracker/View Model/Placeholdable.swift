//
//  Placeholdable.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import Foundation
import InvestmentDataModel

//  Having init with no params
protocol Placeholdable {
    init()
}

extension Entity: Placeholdable {
    init() {
        self.init("", note: "")
    }
}

extension Payment: Placeholdable {
    init() {
        self.init(date: Date(), amount: 1, currency: .rub, sender: Entity(), recipient: Entity(), note: "")
    }
}

extension Project: Placeholdable {
    init() {
        self.init(name: "", note: "", entities: [], payments: [])
    }
}