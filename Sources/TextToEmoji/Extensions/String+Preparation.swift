import Foundation

internal extension String {
    func prepareString() -> String {
        var preparedString = self.lowercased()
        
        guard
            preparedString.components(separatedBy: " ").count > 1,
            let path = Bundle.module.path(forResource: "Adjectives", ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return preparedString }
        
        let whitespace = " "
        allKeys.forEach {
            preparedString = preparedString
                .replacingOccurrences(of: $0, with: "")
                .removePrefix(whitespace)
                .removeSuffix(whitespace)
        }
        
        return preparedString
    }
    
    func removePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(" ") else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeSuffix(_ prefix: String) -> String {
        guard self.hasSuffix(" ") else { return self }
        return String(self.dropLast(prefix.count))
    }
}
