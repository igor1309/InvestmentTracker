//
//  Project Extensions.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import Foundation
import InvestmentDataModel

extension Project {
    
    //    //  MARK: - Entity...
    
    func canDelete(_ entityID: UUID) -> Bool {
        let senderIDs = payments.map { $0.senderID }
        let recipientIDs = payments.map { $0.recipientID }
        let allIDs = senderIDs + recipientIDs
        
        return !allIDs.contains(entityID)
    }
}

