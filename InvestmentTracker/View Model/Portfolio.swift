//
//  Portfolio.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import Combine
import InvestmentDataModel

extension Project {
    
    //  MARK: - Validation
    
    func isValidProject() -> Bool {
        !name.isEmpty && !note.isEmpty
    }
    
    //  MARK: - Entity Handling
    
    mutating func addEntity(_ entity: Entity) -> Bool {
        if entity.isValidEntity() {
            entities.append(entity)
            return true
        }
        return false
    }
    
    mutating func deleteEntity(_ entity: Entity) {
        guard let index = entities.firstIndex(matching: entity) else { return }
        
        entities.remove(at: index)
    }
    
    //  MARK: - Payment Handling
    mutating func addPayment(_ payment: Payment) -> Bool {
        if payment.isValidPayment() {
            payments.append(payment)
            return true
        }
        return false
    }
    
    mutating func deletePayment(_ payment: Payment) {
        guard let index = payments.firstIndex(matching: payment) else { return }
        
        payments.remove(at: index)
    }

}

extension Payment {
    func isValidPayment() -> Bool {
        !(amount != 0) && !sender.name.isEmpty && !recipient.name.isEmpty
    }
}

extension Entity {
    func isValidEntity() -> Bool {
        !name.isEmpty
    }
}
    

final class Portfolio: ObservableObject {
    @Published private(set) var projects: [Project] = Project.projects
    
    init() {
        //  MARK: Add loading projects from JSON
        
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
    
    //  MARK: - Entity handling
    
    func addEntity(_ entity: Entity, to project: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        return projects[index].addEntity(entity)
    }
    
    func deleteEntity(_ entity: Entity, from project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        projects[index].deleteEntity(entity)
    }

    //  MARK: - Payment handling
    
    func addPayment(_ payment: Payment, to project: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        return projects[index].addPayment(payment)
    }
    
    func deletePayment(_ payment: Payment, from project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        projects[index].deletePayment(payment)
    }
    
    //  MARK: - Project handling
    
    func update(_ project: Project, with draft: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        if draft.isValidProject() {
            projects[index] = draft
            return true
        }
        return false
    }
    
    func addProject(_ project: Project) -> Bool {
        if project.isValidProject() {
            projects.append(project)
            return true
        }
        return false
    }
    
    func deleteProject(_ project: Project) {
        if let index = projects.firstIndex(matching: project) {
            projects.remove(at: index)
        }
    }
    
    //  MARK: -
    
    var entities: [Entity] {
        let entities = projects.flatMap { $0.entities }
        let senders = projects.flatMap { $0.payments }.map { $0.sender }
        let recipients = projects.flatMap { $0.payments }.map { $0.recipient }
        
        let all = entities + senders + recipients
        let uniqueEntities = Set(all)
        
        return Array(uniqueEntities).sorted { $0.name < $1.name }
    }
    
    //  MARK: Portfolio Totals
    
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

