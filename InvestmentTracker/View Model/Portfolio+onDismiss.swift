//
//  Portfolio+onDismiss.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 14.07.2020.
//

import SwiftUI
import InvestmentDataModel

extension Portfolio {
    
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
    
    
    
    //  MARK: Functions used as Sheets onDismiss actions
    //  MARK: Add Projects and Investors to Portfolio
    
    func onDismissAdd<T: Identifiable & Validatable>(
        draft: inout T?,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        defer { draft = nil }
        
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
    
    
    //  MARK: Update Projects and Investors in Portfolio
    
    func onDismissUpdate<T: Identifiable & Validatable>(
        draft: inout T?,
        original: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        defer { draft = original }
        
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
    
    
    //  MARK: Add Payments and Entities to Project
    
    func onDismissAdd<T: Identifiable & Validatable>(
        draft: inout T?,
        initialValue: T? = nil,
        to project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        defer { draft = initialValue }
        
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
    
    
    //  MARK: Update Payments and Entities in Project
    
    func onDismissUpdate<T: Identifiable & Validatable>(
        draft: inout T?,
        original: T,
        in project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        defer { draft = original }
        
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
