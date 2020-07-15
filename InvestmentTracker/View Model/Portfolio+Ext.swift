//
//  Portfolio+Ext.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import SwiftUI
import InvestmentDataModel

extension Portfolio {
        
    //  MARK: - Generic functions to handle Projects and Investors
    //          and other possible arrays in Portfolio
    
    func delete<T: Identifiable>(
        _ value: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) -> Bool {
        if let index = self[keyPath: keyPath].firstIndex(matching: value) {
            self[keyPath: keyPath].remove(at: index)
            return true
        }
        return false
    }
    
    //  MARK: - Generic functions to handle Entities and Payments
    
    func delete<T: Identifiable>(
        _ value: T,
        from project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }

        /// find index of the value in project
        guard let valueIndex = project[keyPath: keyPath].firstIndex(matching: value) else { return false }

        /// remove
        projects[index][keyPath: keyPath].remove(at: valueIndex)
        
        return true
    }
}
