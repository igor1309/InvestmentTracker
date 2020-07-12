//
//  EntityRow.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 11.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EntityRow: View {
    @EnvironmentObject var portfolio: Portfolio
    @EnvironmentObject var settings: Settings
    
    var entity: Entity
    var project: Project
    
    @State private var showDeleteAction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(entity.name).tag(entity)
                Spacer()
            }
            if !entity.note.isEmpty {
                Text(entity.note)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button {
                //  MARK: FINISH THIS
            } label: {
                Image(systemName: "square.and.pencil")
                Text("TBD: Edit")
            }
            
            if portfolio.canDelete(entity.id) {
                Button {
                    showDeleteAction = true
                } label: {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
        .actionSheet(isPresented: $showDeleteAction) {
            ActionSheet(
                title: Text("Delete?".uppercased()),
                message: Text("Do you really want to delete '\(entity.name)'?\nThis action cannot be undone."),
                buttons: [
                    .destructive(Text("Yes, delete")) {
                        delete(entity: entity, from: project)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func delete(entity: Entity, from project: Project) {
        let generator = UINotificationFeedbackGenerator()
        
        withAnimation {
            if portfolio.deleteEntity(entity, from: project) {
                generator.notificationOccurred(.success)
            } else {
                generator.notificationOccurred(.error)
            }
        }
    }
}

struct EntityRow_Previews: PreviewProvider {
    static var previews: some View {
        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
            EntityRow(entity: Entity.kitProgressOOO, project: Project())
        }
        .preferredColorScheme(.dark)
    }
}
