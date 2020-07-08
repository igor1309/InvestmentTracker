//
//  InvestmentTrackerApp.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI

import InvestmentDataModel

@main
struct InvestmentTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            Edit_EditorWrapperTest(entity: Entity("Test", note: "Test Entity"))
            //CreatorWrapperTest()
            //ContentView()
        }
    }
}
