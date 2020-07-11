//
//  Validatable.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import Foundation
import InvestmentDataModel

protocol Validatable {
    var isValid: Bool { get }
}

extension Entity: Validatable {
    var isValid: Bool {
        !name.isEmpty
    }
}

extension Payment: Validatable {
    var isValid: Bool {
        amount > 0 && senderID != recipientID
    }
}

extension Project: Validatable {    
    var isValid: Bool {
        !name.isEmpty && !note.isEmpty
    }
}
