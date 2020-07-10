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
    @Binding var entity: Entity
    
    @State private var showEditor = false
    @State private var draft = Entity("", note: "")
    @State private var shouldSave = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(portfolio.entities, id: \.id) { entity in
                    HStack {
                        Text(entity.name).tag(entity)
                            .foregroundColor(color(for: entity))
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.entity = entity
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Entity Picker")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button {
                    //  MARK: FINISH THIS
                    draft = Entity("New Entity", note: "")
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .padding([.vertical, .leading])
                }
                .sheet(isPresented: $showEditor) {
                    //  on Dismiss
                    if shouldSave {
                        //  MARK: FINISH THIS
                        print("saving...")
                        
                        shouldSave = false
                    }
                } content: {
                    EntityEditor(entity: $draft)
                }
            )
        }
    }
    
    func color(for entity: Entity) -> Color {
        self.entity == entity ? Color(UIColor.systemOrange) : .primary
    }
}

struct EntityPicker_Previews: PreviewProvider {
    static var previews: some View {
        EntityPicker(entity: .constant(Entity.progressOOO))
            .preferredColorScheme(.dark)
            .environmentObject(Portfolio())
    }
}
