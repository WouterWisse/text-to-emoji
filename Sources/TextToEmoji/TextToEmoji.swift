import Foundation

public struct TextToEmoji {
    
    public func emoji(for text: String) -> String? {
        let input = text.lowercased()
        let emoji = NSLocalizedString(input, bundle: Bundle.module, value: input, comment: input)
        
        guard emoji != input else { return nil }
        
        return emoji
    }
}
