//
//  Extension+Date.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import Foundation

extension Date {
    func toString(format: String = "dd.MM.yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
