//
//  Portfolio.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

final class Portfolio: ObservableObject {
    @Published var projects: [Project] = Project.projects
}

