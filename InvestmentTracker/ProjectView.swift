//
//  ProjectView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var portfolio: Portfolio
    
    @State private var draft: Project
    
    init(_ project: Project){
        self._draft = State(initialValue: project)
    }
    
    var body: some View {
        NavigationView {
            ProjectEditor(draft)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(Project.saperavi)
            .preferredColorScheme(.dark)
    }
}
