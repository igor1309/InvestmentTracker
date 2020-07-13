//
//  Portfolio+Entity.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import Foundation
import InvestmentDataModel

extension Portfolio {
    
    func isPaymentValid(_ payment: Payment, in project: Project) -> Bool {
        payment.isValid
            && isEntityOk(
                entityID: payment.senderID,
                as: .sender,
                for: payment.type,
                in: project
            )
            && isEntityOk(
                entityID: payment.recipientID,
                as: .recipient,
                for: payment.type,
                in: project
            )
    }
    
    
    //  MARK: - Entities...
    
    func canDelete(_ entityID: UUID) -> Bool {
        let senderIDs = projects.flatMap { $0.payments }.map { $0.senderID }
        let recipientIDs = projects.flatMap { $0.payments }.map { $0.recipientID }
        let allIDs = senderIDs + recipientIDs
        
        return !allIDs.contains(entityID)
    }
    
    func deleteEntity(_ entity: Entity, from project: Project) -> Bool {
        guard canDelete(entity.id) else { return false }
        
        if let _ = investors.firstWithID(entity.id) {
            return delete(entity, keyPath: \.investors)
        }
        
        if let _ = project.entities.firstWithID(entity.id) {
            return delete(entity, from: project, keyPath: \.entities)
        }
        
        return false
    }
    
    func entityForID(_ id: UUID, in project: Project) -> Entity? {
        if let investor = investors.firstWithID(id) {
            return investor
        }
        if let entity = project.entities.firstWithID(id) {
            return entity
        }
        return nil
    }

//  MARK: - entities to pick from: Investors or Project Entities
    
    func entitiesToPickFrom(
        as entityType: EntitySelector.EntityType,
        for paymentType: Payment.PaymentType,
        in project: Project
    ) -> (entities: [Entity], kind: String) {
        switch (entityType, paymentType) {
        case (.sender, .investment), (.recipient, .return):
            return (investors, "investors")
        default:
            return (project.entities, "entities")
        }
    }
    
    //  MARK: - Investor or Entity as payment party (side)

    func isEntityOk(
        entityID: UUID,
        as entityType: EntitySelector.EntityType,
        for paymentType: Payment.PaymentType,
        in project: Project
    ) -> Bool {
        if let entity = entityForID(entityID, in: project) {
            switch (entityType, paymentType) {
            case (.sender, .investment), (.recipient, .return):
                return investors.contains(entity)
            default:
                return project.entities.contains(entity)
            }
        } else {
            return false
        }
    }
}
