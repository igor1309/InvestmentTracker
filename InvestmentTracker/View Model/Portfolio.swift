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
    
    
    
    //  MARK: Add
    
    func onDismissAdd<T: Identifiable & Validatable>(
        draft: inout T?,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        defer { draft = nil }
        
        let generator = UINotificationFeedbackGenerator()
        
        withAnimation {
            if draft == nil {
                print("nothing was created or edit was cancelled")
            } else {
                if add(draft!, keyPath: keyPath) {
                    print("project added ok")
                    generator.notificationOccurred(.success)
                } else {
                    print("error adding project")
                    generator.notificationOccurred(.error)
                }
            }
        }
    }
    
    func onDismissAdd<T: Identifiable & Validatable>(
        draft: inout T?,
        initialValue: T? = nil,
        to project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        defer { draft = initialValue }
        
        let generator = UINotificationFeedbackGenerator()
        
        withAnimation {
            if draft == nil {
                print("nothing was created or edit was cancelled")
            } else {
                if add(draft!, to: project, keyPath: keyPath) {
                    print("project added ok")
                    generator.notificationOccurred(.success)
                } else {
                    print("error adding project")
                    generator.notificationOccurred(.error)
                }
            }
        }
    }
    
    
    //  MARK: Update

    func onDismissUpdate<T: Identifiable & Validatable>(
        draft: inout T?,
        original: T,
        in project: Project,
        keyPath: WritableKeyPath<Project, [T]>
    ) {
        let generator = UINotificationFeedbackGenerator()
        
        if let draft = draft {
            print("Object was edited, ready to use")
            withAnimation {
                if update(draft, in: project, keyPath: keyPath) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
            draft = original
        }
    }
    
    func onDismissUpdate<T: Identifiable & Validatable>(
        draft: inout T?,
        original: T,
        keyPath: ReferenceWritableKeyPath<Portfolio, [T]>
    ) {
        let generator = UINotificationFeedbackGenerator()
        
        if let draft = draft {
            print("Object was edited, ready to use")
            withAnimation {
                if update(draft, keyPath: keyPath) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
            draft = original
        }
    }
}
