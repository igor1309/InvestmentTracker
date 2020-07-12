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
    
    var image: some View {
        let name = payment.type == .investment
            ? "arrow.right.square"
            : "arrow.left.square"
        let color = payment.type == .investment
            ? Color(UIColor.orange)
            : Color(UIColor.green)
        
        return Image(systemName: name)
            .foregroundColor(color.opacity(0.7))
            .font(.system(size: size, weight: .light))
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(payment.date, style: .date)
                    .font(.system(.footnote, design: .monospaced))
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(payment.amount, specifier: "%.f")")
                        .font(.system(.footnote, design: .monospaced))
                }
            }
            .font(.subheadline)
            
            HStack {
                image
                
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
        .contextMenu {
            Button {
                showEditor = true
            } label: {
                Image(systemName: "square.and.pencil")
                Text("Edit")
            }
            .sheet(isPresented: $showEditor) {
                handleEditor()
            } content: {
                EditorWrapper(original: $draft, isPresented: $showEditor) { draft in
                    PaymentEditor(payment: draft, project: project)
                }
                .environmentObject(portfolio)
            }
            Button {
                showDeleteAction = true
            } label: {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
        .actionSheet(isPresented: $showDeleteAction) {
            deleteActionSheet(payment)
        }
    }
    
    private func handleEditor() {
        let generator = UINotificationFeedbackGenerator()
        
        if let draft = draft {
            print("Payment for \(draft.amount) was created or edited, ready to use")
            withAnimation {
                if portfolio.update(draft, in: project, keyPath: \.payments) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
            draft = payment
        }
    }
    
    private func deleteActionSheet(_ payment: Payment) -> ActionSheet {
        ActionSheet(
            title: Text("Delete?".uppercased()),
            message: Text("Do you really want to delete this Payment of \(payment.amount, specifier: "%.f") on \(payment.date, style: .date)?\nThis operation cannot be undone."),
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
        .preferredColorScheme(.dark)
    }
}
