//
//  View+debugPrint.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 10.07.2020.
//

import SwiftUI

/// https://twitter.com/twostraws/status/1280996740053827584?s=20
extension View {
    func debugPrint(_ value: Any) -> some View {
        #if DEBUG
        print(value)
        #endif
        return self
    }
}
