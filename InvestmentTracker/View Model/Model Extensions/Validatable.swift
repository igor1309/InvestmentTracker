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

extension Project: Validatable {
    var isValid: Bool {
        name.count > 2 && note.count > 2
    }
}

extension Entity: Validatable {
    var isValid: Bool {
        name.count > 2
    }
}

extension Payment: Validatable {
    var isValid: Bool {
        amount > 0 && senderID != recipientID
    }
}
