//
//  Portfolio.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

final class Portfolio: ObservableObject {
    @Published private(set) var projects: [Project] = Project.projects
    
    var totalInvestment: Double {
        projects
            .map { $0.totalInflows }
            .reduce(0, +)
    }
    
    var totalReturn: Double {
        projects
            .map { $0.totalOutflows }
            .reduce(0, +)
    }
    
    var totalNetInvestment: Double {
        projects
            .map { $0.netFlows }
            .reduce(0, +)
    }
    
    func npv(rate: Double, present: Date = Date()) -> Double {
        projects
            .map { $0.npv(rate: rate, present: present) }
            .reduce(0, +)
    }
}

