//
//  Portfolio+Ext NOT USED.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import Foundation
import InvestmentDataModel

extension Portfolio {
    
    //  MARK: - Project handling - NOT USED, have generic functions now
    
    private func addProject(_ project: Project) -> Bool {
        if project.isValid {
            projects.append(project)
            return true
        }
        return false
    }
    
    private func update(_ project: Project, with draft: Project) -> Bool {
        guard let index = projects.firstIndex(matching: project) else { return false }
        
        if draft.isValid {
            projects[index] = draft
            return true
        }
        return false
    }
    
    private func deleteProject(_ project: Project) {
        if let index = projects.firstIndex(matching: project) {
            projects.remove(at: index)
        }
    }
}
