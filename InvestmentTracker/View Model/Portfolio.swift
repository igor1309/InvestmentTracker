//
//  Portfolio.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import Combine
import InvestmentDataModel

final class Portfolio: ObservableObject {
    /// `private(set)` doesn't work with ReferenceWritableKeyPath
    @Published /*private(set)*/ var projects: [Project] = Project.projects
    
    init() {
        //  MARK: FINISH THIS: Add loading projects from JSON
        
        $projects
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] in
                self?.save($0)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
    
    //  MARK: Load & Save
    //  MARK: - FINISH THIS!!!
    
    private func load() {
        
    }
    
    private func save(_ projects: [Project]) {
        
    }
    
//    //  MARK: -
//
//    var entities: [Entity] {
//        let entities = projects.flatMap { $0.entities }
//        let senders = projects.flatMap { $0.payments }.map { $0.sender }
//        let recipients = projects.flatMap { $0.payments }.map { $0.recipient }
//
//        let all = entities + senders + recipients
//        let uniqueEntities = Set(all)
//
//        return Array(uniqueEntities).sorted { $0.name < $1.name }
//    }
    
    //  MARK: - Portfolio Totals
    
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
