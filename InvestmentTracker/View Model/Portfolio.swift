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
    @Published /*private(set)*/ var investors: [Entity] = [.igor]
    
    init() {
        //  MARK: FINISH THIS: Add loading projects from JSON
        //  ...
        
        
        $projects
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] in
                self?.save($0, to: "projects.json")
            }
            .store(in: &cancellables)

        $investors
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] in
                self?.save($0, to: "investors.json")
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }

    //  MARK: - entities to pick from: Investors or Project Entities
    
    func entitiesToPickFrom(
        as entityType: EntitySelector.EntityType,
        for paymentType: Payment.PaymentType,
        in project: Project
    ) -> [Entity] {
        switch (entityType, paymentType) {
        case (.sender, .investment), (.recipient, .return):
            return investors
        default:
            return project.entities
        }
    }
    
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
    
    //  MARK: Load & Save
    //  MARK: - FINISH THIS!!!
    
    private func load<T: Decodable>(_ data: T, from file: String) {
        
    }
    
    private func save<T: Encodable>(_ data: T, to file: String) {
        
    }
}
