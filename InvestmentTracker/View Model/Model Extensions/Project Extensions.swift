//
//  Project Extensions.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import Foundation
import InvestmentDataModel

extension Project {
    
//    //  MARK: -
//    
//    var allEntities: [Entity] {
//        let senders = payments.map { $0.sender }
//        let recipients = payments.map { $0.recipient }
//        
//        let all = entities + senders + recipients
//        let uniqueEntities = Set(all)
//        
//        return Array(uniqueEntities).sorted { $0.name < $1.name }
//    }

    
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

