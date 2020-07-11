//
//  EntitySelector.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EntitySelector: View {
    @EnvironmentObject var portfolio: Portfolio
    
    enum EntityType: String {
        case sender, recipient
        
        var id: String { rawValue.capitalized }
        
        var preposition: String {
            switch self {
            case .sender:
                return "from"
            case .recipient:
                return "to"
            }
        }
    }
    
    let type: EntityType
    let paymentType: Payment.PaymentType
    
    @Binding var entityID: UUID
    let project: Project
    
    @State private var draftEntity: Entity?
    @State private var showModal = false
    
    var entityName: String {
        if let entity = portfolio.entityForID(entityID, in: project) {
            return entity.name.isEmpty ? "select…" : entity.name
        } else {
            return "select…"
        }
    }
    
    var isOk: Bool {
        portfolio.isEntityOk(
            entityID: entityID,
            as: type,
            for: paymentType,
            in: project
        )
    }
    
    var header: Text {
        if isOk {
            return Text(type.preposition)
        } else {
            return Text("Error in \(type.id)")
                .foregroundColor(isOk ? .secondary : .red)
        }
    }
    
    var body: some View {
        Section(header: header) {
            Button {
                showModal = true
            } label: {
                Text(entityName)
            }
            .sheet(isPresented: $showModal) {
                EntityPicker(
                    entityID: $entityID,
                    title: "Select Entity",
                    entityType: type,
                    paymentType: paymentType,
                    project: project
                )
                .environmentObject(portfolio)
            }
        }
    }
}

struct EntitySelector_Previews: PreviewProvider {
    @State static var entity = Entity()
    static let project = Project()
    
    @State static var type = Payment.PaymentType.investment
    
    static var previews: some View {
        NavigationView {
            List {
                Picker("Type", selection: $type) {
                    ForEach(Payment.PaymentType.allCases, id: \.self) { type in
                        Text(type.id).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                EntitySelector(
                    type: .sender,
                    paymentType: Payment.PaymentType.investment,
                    entityID: $entity.id,
                    project: project
                )
                EntitySelector(
                    type: .recipient,
                    paymentType: Payment.PaymentType.investment,
                    entityID: $entity.id,
                    project: project
                )
            }
            .listStyle(InsetGroupedListStyle())
        }
        .preferredColorScheme(.dark)
        .environmentObject(Portfolio())
    }
}
