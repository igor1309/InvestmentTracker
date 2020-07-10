//
//  Portfolio+Entity.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import InvestmentDataModel

extension Portfolio {
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
        entity: Entity,
        as entityType: EntitySelector.EntityType,
        for paymentType: Payment.PaymentType,
        in project: Project
    ) -> Bool {
        switch (entityType, paymentType) {
        case (.sender, .investment), (.recipient, .return):
            return investors.contains(entity)
        default:
            return project.entities.contains(entity)
        }
    }
}
