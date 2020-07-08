import Foundation
import InvestmentDataModel

protocol Placeholdable {
    init()
}
extension Entity: Placeholdable {
    init() {
        self.init("", note: "")
    }
}

enum EditorAction { case save, cancel }
enum EditorResult<Value> {
    case value(Value)
    case action(EditorAction)
}

let original: EditorResult = .value(Entity())
