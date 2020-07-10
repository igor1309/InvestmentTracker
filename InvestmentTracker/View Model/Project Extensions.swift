//
//  Project Extensions.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import Foundation
import InvestmentDataModel

extension Project {
    
    //  MARK: - Entity Handling
    
    private mutating func addEntity(_ entity: Entity) -> Bool {
        if entity.isValid {
            entities.append(entity)
            return true
        }
        return false
    }
    
    private mutating func deleteEntity(_ entity: Entity) {
        guard let index = entities.firstIndex(matching: entity) else { return }
        
        entities.remove(at: index)
    }
    
    //  MARK: - Payment Handling
    private mutating func addPayment(_ payment: Payment) -> Bool {
        if payment.isValid {
            payments.append(payment)
            return true
        }
        return false
    }
    
    private mutating func deletePayment(_ payment: Payment) {
        guard let index = payments.firstIndex(matching: payment) else { return }
        
        payments.remove(at: index)
    }

}
