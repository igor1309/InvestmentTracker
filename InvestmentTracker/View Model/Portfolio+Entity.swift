//
//  Portfolio+Entity.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import Foundation
import InvestmentDataModel

extension Portfolio {
    
    //  MARK: - Entities...
    
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
    ) -> [Entity] {
        switch (entityType, paymentType) {
        case (.sender, .investment), (.recipient, .return):
            return investors
        default:
            return project.entities
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
