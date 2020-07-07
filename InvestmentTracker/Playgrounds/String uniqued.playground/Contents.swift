import Foundation

//  Stanford CS193p Lecture 13
extension String {
    func uniqued<StringCollection>(withRespectTo otherStrings: StringCollection) -> String where StringCollection: Collection, StringCollection.Element == String {
        var unique = self
        while otherStrings.contains(unique) {
            unique = unique.incremented
        }
        return unique
    }
    
    var incremented: String {
        let prefix = String(self.reversed().drop(while: { $0.isNumber }).reversed())
        if let number = Int(self.dropFirst(prefix.count)) {
            return "\(prefix)\(number + 1)"
        } else {
            return "\(self) 1"
        }
    }
}

print("test".uniqued(withRespectTo: ["test", "test 1", "test 2"]))
