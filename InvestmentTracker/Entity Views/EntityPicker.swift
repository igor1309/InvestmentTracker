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
    
    var entitiesToPickFrom: (entities: [Entity], kind: String) {
        portfolio.entitiesToPickFrom(as: entityType, for: paymentType, in: project)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: Text("Edit and add \(entitiesToPickFrom.kind) here.\n\(entitiesToPickFrom.kind.capitalized) used in payments can't be deleted.")
                ) {
                    ForEach(entitiesToPickFrom.entities) { entity in
                        EntityRow(entity: entity, project: project)
                            .foregroundColor(color(for: entity))
                            .onTapGesture {
                                self.entityID = entity.id
                                presentation.wrappedValue.dismiss()
                            }
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
                portfolio.addEntityOrInvestor(
                    draft: draft,
                    entityType: entityType,
                    paymentType: paymentType,
                    to: project
                )
                /// reset draft
                draft = nil
            } content: {
                EditorWrapper(
                    isPresented: $showEditor,
                    original: $draft
                ) { entity in
                    entity.isValid
                } editor: { entity in
                    EntityEditor(entity: entity, project: project)
                }
            }
        }
    }
    
    private func color(for entity: Entity) -> Color {
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
