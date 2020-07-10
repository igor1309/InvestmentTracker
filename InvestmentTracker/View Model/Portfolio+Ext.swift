//
//  Portfolio+Ext.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import Foundation
import InvestmentDataModel

extension Portfolio {
    
    //  MARK: - Generic functions to handle Portfolio and Investors
    //          and other possible arrays in Portfolio
    
    func add<T: Identifiable & Validatable>(
        _ value: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) -> Bool {
        if value.isValid {
            self[keyPath: keyPath].append(value)
            return true
        }
        return false
    }
    
    func update<T: Identifiable & Validatable>(
        _ value: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) -> Bool {
        guard let index = self[keyPath: keyPath].firstIndex(matching: value) else { return false }
        
        if value.isValid {
            self[keyPath: keyPath][index] = value
            return true
        }
        return false
    }
    
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
    
    func add<T: Identifiable & Validatable>(
        _ value: T,
        to project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// validate
        guard value.isValid else { return false }
        
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        /// add new element
        projects[index][keyPath: keyPath].append(value)
        
        return true
    }
    
    func update<T: Identifiable & Validatable>(
        _ value: T,
        in project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) -> Bool {
        /// validate
        guard value.isValid else { return false }
        
        /// find index of the project
        guard let index = projects.firstIndex(matching: project) else { return false }

        /// find index of the value in project
        guard let valueIndex = project[keyPath: keyPath].firstIndex(matching: value) else { return false }

        /// update value
        projects[index][keyPath: keyPath][valueIndex] = value
        
        return true
    }
    
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
