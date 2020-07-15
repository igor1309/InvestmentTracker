//
//  Portfolio+onDismiss.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 14.07.2020.
//

import SwiftUI
import InvestmentDataModel

extension Portfolio {
    
    //  MARK: Functions used as Sheets onDismiss actions

    //  MARK: Add Entity or Investor on Dismiss
    //        This is a special case: Investors are at Portfolio level
    //        but Entities are inside Project
    
    func addEntityOnDismiss(
        draft: inout Entity?,
        entityType: EntitySelector.EntityType,
        paymentType: Payment.PaymentType,
        to project: Project
    ) {
        defer { draft = nil }
        
        guard let draft = draft else {
            print("nothing was created or edit was cancelled")
            return
        }
        
        print("Entity with name '\(draft.name)' (\(entityType.id) in \(paymentType.id) payment) was created, ready to use")
        
        withAnimation {
            let isOk: Bool

            switch (entityType, paymentType) {
            case (.sender, .investment), (.recipient, .return):
                /// add investor
                isOk = add(draft, keyPath: \.investors)
            default:
                /// add Entity
                isOk = add(draft, to: project, keyPath: \.entities)
            }

            feedback(isOk)
        }
    }
    
    
    //  MARK: - Handling Projects and Investors in Portfolio
    
    //  MARK: Add Projects and Investors to Portfolio
    
    func addProject(_ draft: Project?) {
        addToPortfolio(draft: draft, keyPath: \.projects)
    }
    
    func addInvestor(_ draft: Entity?) {
        addToPortfolio(draft: draft, keyPath: \.investors)
    }
    
    private func addToPortfolio<T: Identifiable & Validatable>(
        draft: T?,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        guard let draft = draft else {
            print("nothing was created or edit was cancelled")
            return
        }
        
        print("Object was created, ready to use")
        
        withAnimation {
            let isOk = add(draft, keyPath: keyPath)
            feedback(isOk)
        }
    }
    
    private func add<T: Identifiable & Validatable>(
        _ value: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) -> Bool {
        if value.isValid {
            self[keyPath: keyPath].append(value)
            return true
        }
        return false
    }
    

    //  MARK: Update Projects and Investors in Portfolio
    
    func updateProject(_ draft: Project?) {
        updateInPortfolio(draft: draft, keyPath: \.projects)
    }
    
    func updateInvestor(_ draft: Entity?) {
        updateInPortfolio(draft: draft, keyPath: \.investors)
    }
    
    private func updateInPortfolio<T: Identifiable & Validatable>(
        draft: T?,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        guard let draft = draft else {
            print("nothing was created or edit was cancelled")
            return
        }
        
        print("Object was edited, ready to use")
        
        withAnimation {
            let isOk = update(draft, keyPath: keyPath)
            feedback(isOk)
        }
    }
    
    private func update<T: Identifiable & Validatable>(
        _ value: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) -> Bool {
        guard let index = self[keyPath: keyPath].firstIndex(matching: value) else { return false }
        
        if value.isValid {
            self[keyPath: keyPath][index] = value
            return true
        }
        return false
    }
    

    //  MARK: - Handling Projects
    
    //  MARK: Add Payments and Entities to Project
    
    func addEntity(_ draft: Entity?, to project: Project) {
        addToPortfolio(draft: draft, to: project, keyPath: \.entities)
    }
    
    func addPayment(_ draft: Payment?, to project: Project) {
        addToPortfolio(draft: draft, to: project, keyPath: \.payments)
    }
    
    private func addToPortfolio<T: Identifiable & Validatable>(
        draft: T?,
        to project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        guard let draft = draft else {
            print("nothing was created or edit was cancelled")
            return
        }
        
        print("Object was created, ready to use")
        
        withAnimation {
            let isOK = add(draft, to: project, keyPath: keyPath)
            feedback(isOK)
        }
    }
    
    private func add<T: Identifiable & Validatable>(
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
    

    //  MARK: Update Payments and Entities in Project
    
    func updateEntity(_ draft: Entity?, in project: Project) {
        updateInPortfolio(draft: draft, in: project, keyPath: \.entities)
    }
    
    func updatePayment(_ draft: Payment?, in project: Project) {
        updateInPortfolio(draft: draft, in: project, keyPath: \.payments)
    }
    
    private func updateInPortfolio<T: Identifiable & Validatable>(
        draft: T?,
        in project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        guard let draft = draft else {
            print("nothing was created or edit was cancelled")
            return
        }
        
        print("Object was edited, ready to use")
        
        withAnimation {
            let isOk = update(draft, in: project, keyPath: keyPath)
            feedback(isOk)
        }
    }
    
    private func update<T: Identifiable & Validatable>(
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
    

    //  MARK: Feedback Helper
    
    func feedback(_ ok: Bool) {
        let generator = UINotificationFeedbackGenerator()
        if ok {
            print("item/updated added ok")
            generator.notificationOccurred(.success)
        } else {
            print("ERROR adding/updating item")
            generator.notificationOccurred(.error)
        }
    }
}
