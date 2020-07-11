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
                
                VStack(alignment: .trailing, spacing: 0) {
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
            EditorWrapper(original: $original, isPresented: $showModal) { draft in
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
        ProjectRow(project: Project())
            .environmentObject(Portfolio())
            .environmentObject(Settings())
    }
}
