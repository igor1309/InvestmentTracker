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
    
    //  MARK: - Generic functions to handle Entities and Payments
    
    func add<T: Identifiable & Validatable>(
        _ value: T,
        to project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// validate
        guard value.isValid else { return false }
        
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        /// add new element
        projects[index][keyPath: keyPath].append(value)
        
        return true
    }
    
    func update<T: Identifiable & Validatable>(
        _ value: T,
        in project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// validate
        guard value.isValid else { return false }
        
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }

        /// find index of the value in project
        guard let valueIndex = project[keyPath: keyPath].firstIndex(matching: value) else { return false }

        /// update value
        projects[index][keyPath: keyPath][valueIndex] = value
        
        return true
    }
    
    func delete<T: Identifiable & Validatable>(
        _ value: T,
        from project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }

        /// find index of the value in project
        guard let valueIndex = project[keyPath: keyPath].firstIndex(matching: value) else { return false }

        /// remove
        projects[index][keyPath: keyPath].remove(at: valueIndex)
        
        return true
    }

    
    //  MARK: - Entity handling
    
    func addEntity(_ entity: Entity, to project: Project) -> Bool {
        guard entity.isValid else { return false }
        
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        return projects[index].addEntity(entity)
    }
    
    func updateEntity(_ entity: Entity, to project: Project) -> Bool {
        guard entity.isValid else { return false }
        
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        guard let entityIndex = project.entities.firstIndex(matching: entity) else { return false }
        
        projects[index].entities[entityIndex] = entity
        
        return true
    }
    
    func deleteEntity(_ entity: Entity, from project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        projects[index].deleteEntity(entity)
    }

    //  MARK: - Payment handling
    
    func addPayment(_ payment: Payment, to project: Project) -> Bool {
        guard payment.isValid else { return false }
        
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        return projects[index].addPayment(payment)
    }
    
    func updatePayment(_ payment: Payment, in project: Project) -> Bool {
        guard payment.isValid else { return false }
        
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        guard let paymentIndex = project.payments.firstIndex(matching: payment) else { return false }
        
        projects[index].payments[paymentIndex] = payment
        
        return true
    }
    
    func deletePayment(_ payment: Payment, from project: Project) {
        guard let index = projects.firstIndex(matching: project) else { return }
        
        projects[index].deletePayment(payment)
    }
    
    //  MARK: - Project handling
    
    func update(_ project: Project, with draft: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        if draft.isValid {
            projects[index] = draft
            return true
        }
        return false
    }
    
    func addProject(_ project: Project) -> Bool {
        if project.isValid {
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

