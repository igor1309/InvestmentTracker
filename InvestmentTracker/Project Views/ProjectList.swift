//
//  ProjectList.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectList: View {
    @EnvironmentObject var portfolio: Portfolio
    @EnvironmentObject var settings: Settings
    
    @State private var showSettings = false
    @State private var showEditor = false
    
    @State private var draft: Project?
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: allProjectsTotals
                        .textCase(.none)
                ) {
                    ForEach(portfolio.projects) { project in
                        NavigationLink(
                            destination: ProjectView(project: project)
                        ) {
                            ProjectRow(project: project)
                        }
                    }
                }
            }
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor(named: "Background")
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Projects")
            .navigationBarItems(
                leading: showSettingsButton
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                            .environmentObject(settings)
                    }
                ,
                trailing: plusButton
                    .sheet(isPresented: $showEditor) {
                        EditorWrapper(draft) {
                            project in
                            project.isValid
                        } handler: { project in
                            portfolio.addProject(project)
                            /// reset draft
                            draft = nil
                            /// dismiss sheet
                            showEditor = false
                        } editor: { project in
                            ProjectEditor(project: project)
                        }
                        .environmentObject(portfolio)
                    }
            )
        }
    }
    
    private var showSettingsButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private var plusButton: some View {
        Button {
            showEditor = true
        } label: {
            Image(systemName: "plus")
                .padding([.vertical, .leading])
        }
    }
    
    private var allProjectsTotals: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("Total Investment")
                Spacer()
                Text("\(portfolio.totalInvestment, specifier: "%.f")")
                    .font(.system(.footnote, design: .monospaced))
            }
            .foregroundColor(Color(UIColor.systemOrange))
            
            HStack(alignment: .firstTextBaseline) {
                Text("Total Return")
                Spacer()
                Text("\(portfolio.totalReturn, specifier: "%.f")")
                    .font(.system(.footnote, design: .monospaced))
            }
            .foregroundColor(Color(UIColor.green).opacity(0.7))
            
            HStack(alignment: .firstTextBaseline) {
                Text("Total Net Investment")
                Spacer()
                Text("\(portfolio.totalNetInvestment, specifier: "%.f")")
                    .font(.system(.footnote, design: .monospaced))
            }
            .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline) {
                Text("NPV")
                Spacer()
                Text("\(portfolio.npv(rate: settings.rate), specifier: "%.f")")
                    .font(.system(.footnote, design: .monospaced))
            }
            .foregroundColor(Color(UIColor.systemTeal))
            
            Text("Projects (\(portfolio.projects.count)):")
                .foregroundColor(.primary)
                .font(.subheadline)
        }
        .font(.footnote)
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
            .environmentObject(Portfolio())
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
