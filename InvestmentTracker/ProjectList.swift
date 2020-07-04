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
            .listStyle(PlainListStyle())
            .navigationTitle("Projects")
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
        VStack(alignment: .leading, spacing: 3) {
            
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {                        Text(project.name)
                    
                    Text(project.note)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 3) {                        Text("\(project.totalInflows, specifier: "%.f")")
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
            .environmentObject(Settings())
    }
}
