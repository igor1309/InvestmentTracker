//
//  EntityListEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct EntityListEditor: View {
    @Binding var project: Project
    
    var body: some View {
        //  MARK: FINISH THIS
        
        Text("TBD: EntityListEditor")
    }
}

struct EntityListEditor_Previews: PreviewProvider {
    static var previews: some View {
        EntityListEditor(project: .constant(Project.natachtari))
    }
}
