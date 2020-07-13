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
    
    @State private var original: Project?
    
    @State private var showModal = false
    @State private var showDeleteAction = false
    
    init(project: Project) {
        self.project = project
        self._original = State(initialValue: project)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            Text(project.id.uuidString)
                .font(.caption2)
            
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
                showModal = true
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
        .sheet(isPresented: $showModal) {
            // onDismiss
            handleEditorOnDismiss()
        } content: {
            EditorWrapper(
                original: $original,
                isPresented: $showModal
            ) { draft in
                draft.isValid
            } editor: { draft in
                ProjectEditor(draft: draft)
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
    
    private func handleEditorOnDismiss() {
        defer { original = nil }
        
        let generator = UINotificationFeedbackGenerator()
        
        if let original = original {
            print("Project with name '\(original.name)' was created or edited, ready to use")
            withAnimation {
                if portfolio.update(original, keyPath: \.projects) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
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
