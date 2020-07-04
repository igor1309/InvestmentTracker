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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(portfolio.projects) { project in
                    NavigationLink(
                        destination: PaymentList(project: project)
                    ) {
                        projectRow(project)
                    }
                }
            }
//            .listStyle(GroupedListStyle())
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            )
            .sheet(isPresented: $showSettings, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
                SettingsView()
                    .environmentObject(settings)
            }
        }
    }
    
    private func projectRow(_ project: Project) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(project.name)
                    
                    Spacer()
                    
                    Text("\(project.netFlows, specifier: "%.f")")
                        .foregroundColor(Color(UIColor.systemOrange))
                        .font(.footnote)
                }
                Text(project.note)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Spacer()
                    Text("+\(project.totalInflows, specifier: "%.f")")
                }
                
                if project.totalOutflows > 0 {
                    HStack {
                        Spacer()
                        Text("-\(project.totalOutflows, specifier: "%.f")")
                    }
                }
            }
            .foregroundColor(.secondary)
            .font(.footnote)
        }
        .contextMenu {
            Button {
                
            } label: {
                Image(systemName: "plus")
                Text("Add smth")
            }
        }
    }
}
struct ProjectList_Previews: PreviewProvider {
    @StateObject static var portfolio = Portfolio()
    static var previews: some View {
        ProjectList(portfolio: portfolio)
            .preferredColorScheme(.dark)
    }
}
