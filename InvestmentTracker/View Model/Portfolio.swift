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
    
    func addProject(_ project: Project) -> Bool {
        if projectIsValid(project) {
            projects.append(project)
            return true
        }
        return false
    }
    
    private func projectIsValid(_ project: Project) -> Bool {
        !project.name.isEmpty && !project.note.isEmpty
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
    }
    
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

