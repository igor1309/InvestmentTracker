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
    
    @State private var draft: Project = .natachtari
    @State private var draftEntity: Entity = .empty()
    @State private var draftPayment: Payment = .empty()
    @State private var shouldSave = false
    
    enum Modal { case entityEditor, paymentEditor, projectEditor }
    
    @State private var modal: Modal = .projectEditor
    @State private var showModal = false
    
    @State private var showAddAction = false
    @State private var showDeleteAction = false
    
    var body: some View {
        Form {
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
                            destination: PaymentView(payment: payment)
                                .environmentObject(portfolio)
                        ) {
                            PaymentRow(payment: payment)
                                .contextMenu {
                                    Button {
                                        showDeleteAction = true
                                    } label: {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                    .actionSheet(isPresented: $showDeleteAction) {
                                        deleteActionSheet(payment)
                                    }
                                }
                        }
                    }
                }
            }
            
        }
        .navigationTitle(project.name)
        .navigationBarItems(
            trailing: HStack {
                plusButton()
                editButton()
                    .sheet(isPresented: $showModal) {
                        handleEditors() // onDismiss
                    } content: {
                        presentModal()
                    }
            }
        )
    }
    
    private func deleteActionSheet(_ payment: Payment) -> ActionSheet {
        ActionSheet(
            title: Text("Delete?".uppercased()),
            message: Text("Do you really want to delete this Payment of \(payment.currency.symbol)\(payment.amount, specifier: "%.f") on \(payment.date, style: .date)?\nThis operation cannot be undone."),
            buttons: [
                .destructive(Text("Yes, delete")) {
                    withAnimation {
                        portfolio.deletePayment(payment, from: project)
                    }
                },
                .cancel()
            ])
    }
    
    private func handleEditors() {
        if shouldSave {
            let generator = UINotificationFeedbackGenerator()
            
            switch modal {
            case .projectEditor:
                if draft != project {
                    withAnimation {
                        if portfolio.update(project, with: draft) {
                            generator.notificationOccurred(.success)
                        } else {
                            generator.notificationOccurred(.error)
                        }
                    }
                }
            case .entityEditor:
                withAnimation {
                    if portfolio.addEntity(draftEntity, to: project) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                }
            case .paymentEditor:
                withAnimation {
                    if portfolio.addPayment(draftPayment, to: project) {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                }
            }
            
            shouldSave = false
        }
    }
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .entityEditor:
            EntityEditor(entity: $draftEntity, shouldSave: $shouldSave)
                .environmentObject(portfolio)
        case .paymentEditor:
            PaymentEditor(draft: $draftPayment, shouldSave: $shouldSave)
                .environmentObject(portfolio)
        case .projectEditor:
            ProjectEditor(draft: $draft, shouldSave: $shouldSave)
                .environmentObject(portfolio)
        }
    }
    
    private func plusButton() -> some View {
        Button {
            showAddAction = true
        } label: {
            Image(systemName: "plus")
                .padding()
        }
        .actionSheet(isPresented: $showAddAction) { selectWhatToAdd() }
    }
    
    private func editButton() -> some View {
        Button("Edit") {
            draft = project
            modal = .projectEditor
            showModal = true
        }
    }
    
    private func selectWhatToAdd() -> ActionSheet {
        func addEntity() {
            shouldSave = false
            draftEntity = Entity("", note: "")
            modal = .entityEditor
            showModal = true
        }
        
        func addPayment() {
            shouldSave = false
            draftPayment = Payment.empty()
            modal = .paymentEditor
            showModal = true
        }
        
        return ActionSheet(
            title: Text("Add".uppercased()),
            message: Text("What would you like to add to the Project?"),
            buttons: [
                .default(Text("Add Entity")) { addEntity() },
                .default(Text("Add Payment")) { addPayment() },
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
