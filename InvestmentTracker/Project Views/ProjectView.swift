//
//  ProjectView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

extension Payment: Comparable {
    public static func < (lhs: Payment, rhs: Payment) -> Bool {
        lhs.date < rhs.date
    }
}

//  MARK: USE THIS in ActionSheet message after figuring out how to format date and amount
//extension Payment: CustomStringConvertible {
//    public var description: String {
//        "Payment of \(currency.symbol)\(amount, specifier: "%.f") on \(date, style: .date) from \(sender.name) to \(recipient.name)"
//    }
//}


struct ProjectView: View {
    //  need it here to fix error with dismissing modal by buttons in EditorWrapper
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var portfolio: Portfolio
    @EnvironmentObject var settings: Settings
    
    let project: Project
    
    @State private var draftEntity: Entity?
    @State private var draftPayment: Payment?
    
    enum Modal { case entityEditor, paymentEditor }
    
    @State private var modal: Modal = .paymentEditor
    @State private var showModal = false
    
    @State private var showAddAction = false
    
    var body: some View {
        List {
            Text(project.note)
            
            investmentSection()
            
            if !project.entities.isEmpty {
                Section(header: Text("Entities".uppercased())) {
                    Text(project.entities.map { $0.name }.joined(separator: "; "))
                }
            }
            
            if !project.payments.isEmpty {
                Section(
                    header: Text("Payments".uppercased())
                ) {
                    ForEach(project.payments.sorted(by: >)) { payment in
                        NavigationLink(
                            destination: PaymentView(payment: payment, in: project)
                                .environmentObject(portfolio)
                        ) {
                            PaymentRow(payment: payment, project: project)
                        }
                    }
                }
            }
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(project.name)
        .navigationBarItems(
            trailing: HStack {
                plusButton()
                    .sheet(isPresented: $showModal) {
                        // onDismiss
                        handleEditorsOnDismiss()
                    } content: {
                        presentModal()
                    }
            }
        )
    }
    
    private func handleEditorsOnDismiss() {
        let generator = UINotificationFeedbackGenerator()
        
        switch modal {
        case .entityEditor:
            if let draftEntity = draftEntity {
                print("Entity with name '\(draftEntity.name)' was created or edited, ready to use")
                withAnimation {
                    if portfolio.add(draftEntity, to: project, keyPath: \.entities) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                }
            } else {
                print("nothing was created or edit was cancelled")
            }
        case .paymentEditor:
            if let draftPayment = draftPayment {
                print("Payment for \(draftPayment.currency.symbol)\(draftPayment.amount) was created or edited, ready to use")
                withAnimation {
                    if portfolio.add(draftPayment, to: project, keyPath: \.payments) {
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
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .entityEditor:
            EditorWrapper(original: $draftEntity, isPresented: $showModal) { draft in
                EntityEditor(entity: draft, project: project)
            }
            .environmentObject(portfolio)
        case .paymentEditor:
            EditorWrapper(original: $draftPayment, isPresented: $showModal) { draft in
                PaymentEditor(payment: draft, project: project)
            }
            .environmentObject(portfolio)
        }
    }
    
    private func plusButton() -> some View {
        Button {
            showAddAction = true
        } label: {
            Image(systemName: "plus")
                .padding([.vertical, .leading])
        }
        .actionSheet(isPresented: $showAddAction) { selectWhatToAdd()   }
    }
    
    private func selectWhatToAdd() -> ActionSheet {
        func addEntity() {
            modal = .entityEditor
            showModal = true
        }
        
        func addPayment() {
            modal = .paymentEditor
            showModal = true
        }
        
        return ActionSheet(
            title: Text("Add".uppercased()),
            message: Text("What would you like to add to the Project?"),
            buttons: [
                .default(Text("Add Payment")) { addPayment() },
                .default(Text("Add Entity")) { addEntity() },
                .cancel()
            ]
        )
    }
    
    private func investmentSection() -> some View {
        Section(header: Text("Investment & Return".uppercased())) {
            VStack(spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Total Investment")
                    Spacer()
                    Text("\(project.totalInflows, specifier: "%.f")")
                        .font(.system(.subheadline, design: .monospaced))
                }
                .foregroundColor(Color(UIColor.systemOrange))
                
                if project.totalOutflows >= 0 {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Return")
                        Spacer()
                        Text("\(project.totalOutflows, specifier: "%.f")")
                            .font(.system(.subheadline, design: .monospaced))
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Net")
                    Spacer()
                    Text("\(project.netFlows, specifier: "%.f")")
                        .font(.system(.subheadline, design: .monospaced))
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Text("NPV")
                    Spacer()
                    Text("\(project.npv(rate: settings.rate), specifier: "%.f")")
                        .font(.system(.subheadline, design: .monospaced))
                }
                .foregroundColor(Color(UIColor.systemTeal))
            }
            .padding(.vertical, 3)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.natachtari)
                .environmentObject(Portfolio())
                .environmentObject(Settings())
        }
        .preferredColorScheme(.dark)
    }
}
