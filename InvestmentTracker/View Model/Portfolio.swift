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
    
    
    //  MARK: Project handling
    
    func addEntity(_ entity: Entity, to project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        projects[index].entities.append(entity)
    }
    
    func addPayment(_ payment: Payment, to project: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        if paymentIsValid(payment) {
            projects[index].payments.append(payment)
            return true
        }
        
        return false
    }
    
    private func paymentIsValid(_ payment: Payment) -> Bool {
        !(payment.amount != 0) && !payment.sender.name.isEmpty && !payment.recipient.name.isEmpty
    }
    
    func deletePayment(_ payment: Payment, from project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        guard let paymentIndex = projects[index].payments.firstIndex(matching: payment) else { return }
        
        projects[index].payments.remove(at: paymentIndex)
    }
    
    func update(_ project: Project, with draft: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        if projectIsValid(draft) {
            projects[index] = draft
        }
    }
    
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

