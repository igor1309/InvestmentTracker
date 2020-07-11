//
//  Portfolio.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import Combine
import InvestmentDataModel

final class Portfolio: ObservableObject {
    /// `private(set)` doesn't work with ReferenceWritableKeyPath
    @Published /*private(set)*/ var projects: [Project] = Project.projects
    @Published /*private(set)*/ var investors: [Entity] = [.igor]
    
    init() {
        //  MARK: FINISH THIS: Add loading projects from JSON
        //  ...
        
        
        $projects
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] in
                self?.save($0, to: "projects.json")
            }
            .store(in: &cancellables)

        $investors
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global())
            .sink { [weak self] in
                self?.save($0, to: "investors.json")
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        for cancell in cancellables {
            cancell.cancel()
        }
    }
    
    //  MARK: - Load & Save
    //  MARK: - FINISH THIS!!!
    
    private func load<T: Decodable>(_ data: T, from file: String) {
        
    }
    
    private func save<T: Encodable>(_ data: T, to file: String) {
        
    }
}
