//
//  EntityPicker.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EntityPicker: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var portfolio: Portfolio
    
    @Binding var entityID: UUID
    
    let title: String// = "Select Entity"
    let entityType: EntitySelector.EntityType
    let paymentType: Payment.PaymentType
    let project: Project
    
    @State private var draft: Entity?
    @State private var showEditor = false
    
    var entities: [Entity] {
        portfolio.entitiesToPickFrom(as: entityType, for: paymentType, in: project)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entities) { entity in
                    EntityRow(entity: entity, project: project)
                        .foregroundColor(color(for: entity))
                        .onTapGesture {
                            self.entityID = entity.id
                            presentation.wrappedValue.dismiss()
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button {
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .padding([.vertical, .leading])
                }
            )
            .sheet(isPresented: $showEditor) {
                ///  on Dismiss
                handleEditorOnDismiss()
            } content: {
                EditorWrapper(original: $draft, isPresented: $showEditor) { draft in
                    EntityEditor(entity: draft, project: project)
                }
            }
        }
    }
    
    private func handleEditorOnDismiss() {
        if let draft = draft {
            print("Entity with name '\(draft.name)' was created or edited, ready to use")
            
            let generator = UINotificationFeedbackGenerator()
            
            withAnimation {
                switch (entityType, paymentType) {
                case (.sender, .investment), (.recipient, .return):
                    /// add investor
                    if portfolio.add(draft, keyPath: \.investors) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                default:
                    /// add Entity
                    if portfolio.add(draft, to: project, keyPath: \.entities) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
        }
    }
    
    func color(for entity: Entity) -> Color {
        self.entityID == entity.id ? Color(UIColor.systemOrange) : .primary
    }
}

struct EntityPicker_Previews: PreviewProvider {
    @State static var entity = Entity.progressOOO
    static let project = Project()//.natachtari
    
    static var previews: some View {
        EntityPicker(
            entityID: $entity.id,
            title: "Select Entity",
            entityType: EntitySelector.EntityType.sender,
            paymentType: Payment.PaymentType.investment,
            project: project
        )
        .preferredColorScheme(.dark)
        .environmentObject(Portfolio())
    }
}
