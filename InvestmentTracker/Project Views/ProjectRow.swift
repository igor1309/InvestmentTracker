//
//  ProjectRow.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectRow: View {
    @EnvironmentObject var portfolio: Portfolio
    @EnvironmentObject var settings: Settings
    
    var project: Project
    
    init(project: Project) {
        self.project = project
        self._draft = State(initialValue: project)
    }
    
    @State private var draft: Project?
    
    @State private var showEditor = false
    @State private var showDeleteAction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            if settings.showUUID {
                Text(project.id.uuidString)
                    .font(.caption2)
            }
            
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
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(project.currency.symbol) \(project.totalInflows, specifier: "%.f")")
                        .foregroundColor(Color(UIColor.systemOrange))
                    
                    if project.totalOutflows > 0 {
                        Text("\(project.totalOutflows, specifier: "%.f")")
                            .foregroundColor(Color(UIColor.green).opacity(0.7))
                    }
                    
                    Text("\(project.netFlows, specifier: "%.f")")
                    
                    Text("\(project.npv(rate: settings.rate), specifier: "%.f")")
                        .foregroundColor(Color(UIColor.systemTeal))
                }
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contextMenu {
            Button {
                showEditor = true
            } label: {
                Image(systemName: "square.and.pencil")
                Text("Edit")
            }
            
            Button {
                showDeleteAction = true
            } label: {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
        .sheet(isPresented: $showEditor) {
            EditorWrapper(draft) { project in
                project.isValid
            } handler: { project in
                portfolio.updateProject(project)
                /// reset draft
                self.draft = self.project
                /// dismiss sheet
                showEditor = false
            } editor: { project in
                ProjectEditor(project: project)
            }
            .environmentObject(portfolio)
        }
        .actionSheet(isPresented: $showDeleteAction) {
            func delete() {
                let generator = UINotificationFeedbackGenerator()
                
                withAnimation {
                    if portfolio.delete(project, keyPath: \.projects) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                }
            }
            
            return ActionSheet(
                title: Text("Delete".uppercased()),
                message: Text("Do you really want to delete project '\(project.name)'?\nThis action cannot be undone."),
                buttons: [
                    .destructive(Text("Yes, delete"), action: delete),
                    .cancel()
                ]
            )
        }
    }
}

struct ProjectRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProjectRow(project: Project.natachtari)
                ProjectRow(project: Project.vaiMe)
                ProjectRow(project: Project.saperavi)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .environmentObject(Portfolio())
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
