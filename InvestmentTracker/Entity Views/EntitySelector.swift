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
        case sender = "Sender"
        case recipient = "Recipient"
        
        var header: String {
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
    
    @Binding var entity: Entity
    let project: Project
    
    @State private var draftEntity: Entity?
    @State private var showModal = false
    
    var isOk: Bool {
        portfolio.isEntityOk(
            entity: entity,
            as: type,
            for: paymentType,
            in: project
        )
    }
    
    var body: some View {
        Section(
            header: Text(type.header.uppercased()),
            footer: Text(isOk ? "" : "NOT OK")
                .foregroundColor(isOk ? .secondary : .red)
        ) {
            Button {
                showModal = true
            } label: {
                Text(entity.name.isEmpty ? "select…" : entity.name)
            }
            .sheet(isPresented: $showModal) {
                EntityPicker(
                    entity: $entity,
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
                    entity: $entity,
                    project: project
                )
                EntitySelector(
                    type: .recipient,
                    paymentType: Payment.PaymentType.investment,
                    entity: $entity,
                    project: project
                )
            }
            .listStyle(InsetGroupedListStyle())
        }
        .preferredColorScheme(.dark)
        .environmentObject(Portfolio())
    }
}
