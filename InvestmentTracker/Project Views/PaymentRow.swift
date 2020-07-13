//
//  PaymentRow.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct PaymentRow: View {
    @EnvironmentObject var portfolio: Portfolio
    @EnvironmentObject var settings: Settings
    
    let payment: Payment
    let project: Project
    
    init(payment: Payment, in project: Project) {
        self.project = project
        self.payment = payment
        _draft = State(initialValue: payment)
    }
    
    @State private var draft: Payment?
    @State private var showEditor = false
    
    @State private var showDeleteAction = false
    
    @ScaledMetric var size: CGFloat = 24
    
    @ViewBuilder var paymentTypeImage: some View {
        let color: Color = {
            let color = payment.type == .investment
                ? Color(UIColor.orange)
                : Color(UIColor.green)
            let opacity = 0.7
            return color.opacity(opacity)
        }()
        
        let name = payment.type == .investment
            ? "arrow.right.square"
            : "arrow.left.square"
        
        if settings.compactRow {
            Image(systemName: "circle.fill")
                .imageScale(.small)
                .foregroundColor(color)
        } else {
            Image(systemName: name)
                .foregroundColor(color)
                .font(.system(size: size, weight: .light))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                if settings.compactRow {
                    paymentTypeImage
                }
                
                Text(payment.date, style: .date)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(payment.amount, specifier: "%.f")")
                }
            }
            .font(.system(.footnote, design: .monospaced))
            
            if settings.showUUID {
                Text(payment.id.uuidString)
                    .font(.caption2)
            }
            
            if !settings.compactRow {
                HStack {
                    paymentTypeImage
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("from \(portfolio.entityForID(payment.senderID, in: project)?.name ?? "") to \(portfolio.entityForID(payment.recipientID, in: project)?.name ?? "")")
                        if !payment.note.isEmpty {
                            Text(payment.note)
                        }
                    }
                }
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .font(.footnote)
            }
        }
        .contextMenu {
            Button {
                showEditor = true
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
        .sheet(isPresented: $showEditor) {
            portfolio.onDismissUpdate(
                draft: &draft,
                original: payment,
                in: project,
                keyPath: \.payments
            )
        } content: {
            EditorWrapper(
                original: $draft,
                isPresented: $showEditor
            ) { draft in
                draft.isValid
            } editor: { draft in
                PaymentEditor(payment: draft, project: project)
            }
            .environmentObject(portfolio)
        }
        .actionSheet(isPresented: $showDeleteAction) {
            deleteActionSheet(payment)
        }
    }
    
    private func deleteActionSheet(_ payment: Payment) -> ActionSheet {
        ActionSheet(
            title: Text("Delete?".uppercased()),
            message: Text("Do you really want to delete this Payment of \(project.currency.symbol)\(payment.amount, specifier: "%.f") on \(payment.date, style: .date)?\nThis operation cannot be undone."),
            buttons: [
                .destructive(Text("Yes, delete")) {
                    delete(payment, from: project)
                },
                .cancel()
            ]
        )
    }
    
    private func delete(_ payment: Payment, from project: Project) {
        let generator = UINotificationFeedbackGenerator()
        withAnimation {
            if portfolio.delete(payment, from: project, keyPath: \.payments) {
                generator.notificationOccurred(.success)
            } else {
                generator.notificationOccurred(.error)
            }
        }
    }
}

struct PaymentRow_Previews: PreviewProvider {
    static let payment = Payment(date: Date(), amount: 3_000_000, type: .return, senderID: UUID(), recipientID: UUID(), note: "Return")
    
    static var previews: some View {
        NavigationView {
            List {
                PaymentRow(payment: payment, in: Project())
                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    PaymentRow(payment: Payment.payment01, in: Project())
                }
            }
        }
        .environmentObject(Portfolio())
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
