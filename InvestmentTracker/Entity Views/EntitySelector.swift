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
    
    var body: some View {
        Section(header: Text(type.header.uppercased())) {
            //            Picker(type.rawValue, selection: $entity) {
            //                //  MARK: WHY portfolio.entities????????? SHOULD BE project????
            //                ForEach(portfolio.entities, id: \.id) { entity in
            //                    Text(entity.name).tag(entity)
            //                }
            //                .debugPrint("payment.sender: \(entity)")
            //            }
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
    
    static var previews: some View {
        NavigationView {
            List {
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
