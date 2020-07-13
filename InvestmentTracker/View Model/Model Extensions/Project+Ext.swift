//
//  Project+Ext.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 12.07.2020.
//

import Foundation
import InvestmentDataModel

extension Project {
    func lastPaymentCopy() -> Payment? {
        if let date = payments.map({ $0.date}).max() {
            let lastPayment = payments.first { $0.date == date }!
            return Payment(
                date: Date(),
                amount: 1_000_000,
                type: lastPayment.type,
                senderID: lastPayment.senderID,
                recipientID: lastPayment.recipientID,
                note: "..."
            )
        } else {
            return nil
        }
    }
    
    private var lastPayment: Payment? {
        if let date = payments.map({ $0.date}).max() {
            return payments.first { $0.date == date }
        } else {
            return nil
        }
    }
    
}
