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
    
    let project: Project
    
    @State private var draft: Entity?
    @State private var showEditor = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(project.allEntities, id: \.id) { entity in
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
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Entity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button {
                    //  MARK: FINISH THIS
//                    draft = Entity("New Entity", note: "")
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .padding([.vertical, .leading])
                }
                .sheet(isPresented: $showEditor) {
                    //  on Dismiss
                    handleEditorOnDismiss()
                } content: {
                    EditorWrapper(original: $draft, isPresented: $showEditor) { draft in
                        EntityEditor(entity: draft, project: project)
                    }
                }
            )
        }
    }
    
    private func handleEditorOnDismiss() {
        if let draft = draft {
            print("Entity with name '\(draft.name)' was created or edited, ready to use")
        
            let generator = UINotificationFeedbackGenerator()

            withAnimation {
                if portfolio.add(draft, to: project, keyPath: \.entities) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        } else {
            print("nothing was created or edit was cancelled")
        }
    }
    
    func color(for entity: Entity) -> Color {
        self.entity == entity ? Color(UIColor.systemOrange) : .primary
    }
}

struct EntityPicker_Previews: PreviewProvider {
    @State static var entity = Entity.progressOOO
    static let project = Project()//.natachtari
    
    static var previews: some View {
        EntityPicker(entity: $entity, project: project)
            .preferredColorScheme(.dark)
            .environmentObject(Portfolio())
    }
}
