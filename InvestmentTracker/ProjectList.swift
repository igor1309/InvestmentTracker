//
//  ProjectList.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectList: View {
    @EnvironmentObject var settings: Settings
    @StateObject var portfolio: Portfolio
    
    @State private var showSettings = false
    @State private var showProjectEditor = false
    @State private var draft: Project = .natachtari
    @State private var shouldSave = false
    @State private var showAction = false
    
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
                                .environmentObject(portfolio)
                        ) {
                            projectRow(project)
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
                    .sheet(isPresented: $showProjectEditor) {
                        //  onDismiss
                        handleProjectEditor()
                    } content: {
                        AddProject(
                            draft: $draft,
                            isPresented: $showProjectEditor,
                            shouldSave: $shouldSave
                        )
                        .environmentObject(portfolio)
                    }
            )
        }
    }
    
    private func handleProjectEditor() {
        if shouldSave {
            let generator = UINotificationFeedbackGenerator()
            withAnimation {
                if portfolio.addProject(draft) {
                    print("project added ok")
                    generator.notificationOccurred(.success)
                } else {
                    print("error adding project")
                    generator.notificationOccurred(.error)
                }
            }
            shouldSave = false
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
            draft = Project()
            showProjectEditor = true
        } label: {
            Image(systemName: "plus")
                .padding([.vertical, .leading])
        }
    }
    
    private var allProjectsTotals: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text("No of Projects")
                Spacer()
                Text("\(portfolio.projects.count)")
                    .font(.system(.footnote, design: .monospaced))
            }
            
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
            .foregroundColor(.secondary)
            
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
            
            Text("Projects:")
                .foregroundColor(.primary)
                .font(.headline)
                .padding(.top)
        }
        .font(.footnote)
    }
    
    private func projectRow(_ project: Project) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(project.name)
                        .font(.title3)
                        .bold()
                    
                    Text(project.note)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(project.totalInflows, specifier: "%.f")")
                        .font(.system(.footnote, design: .monospaced))
                    Text("total investment")
                        .font(.caption2)
                }
                .foregroundColor(Color(UIColor.systemOrange))
            }
            
            VStack(alignment: .trailing, spacing: 2) {
                if project.totalOutflows > 0 {
                    Text("return \(project.totalOutflows, specifier: "%.f")")
                }
                
                Text("net \(project.netFlows, specifier: "%.f")")
                
                Text("npv \(project.npv(rate: settings.rate), specifier: "%.f")")
                    .foregroundColor(Color(UIColor.systemTeal))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(.secondary)
            .font(.system(.caption, design: .monospaced))
        }
        .padding(.vertical, 8)
        .contextMenu {
            Button {
                showAction = true
            } label: {
                Image(systemName: "trash")
                Text("Delete")
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(
                    title: Text("Delete".uppercased()),
                    message: Text("Do you really want to delete \(project.name)?\nThis action cannot be undone."),
                    buttons: [
                        .destructive(Text("Yes, delete"), action: {
                            withAnimation {
                                portfolio.deleteProject(project)
                            }
                        }),
                        .cancel()
                    ]
                )
            }
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    @StateObject static var portfolio = Portfolio()
    static var previews: some View {
        ProjectList(portfolio: portfolio)
            .preferredColorScheme(.dark)
            .environmentObject(Settings())
    }
}
