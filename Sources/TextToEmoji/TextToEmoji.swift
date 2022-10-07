import Foundation

public enum TextToEmojiError: Error {
    case noMatchFound
}

public struct TextToEmoji {
    private let stringMatchScoreProvider: StringMatchScoreProvider = .default
    public init() {}
    
    /**
     Will try to match the given text with an emoji.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Shrimp" could match 🦐 and 🍤.
     - Passing `.animalsAndNature` will return 🦐.
     - Passing `.foodAndDrink` will return 🍤.
     - Parameter text: The text that will be matched with an emoji
     - Parameter preferredCategory: The preferred category can be useful when looking for specific sets of emoji
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil
    ) async throws -> String? {
        try await localizedEmoji(for: text, category: preferredCategory)
    }
}

// MARK: Localized Emoji

private extension TextToEmoji {
    func localizedEmoji(
        for text: String,
        category: EmojiCategory?
    ) async throws -> String {
        let emojiTask = Task {
            let input = text.prepareString()
            
            var allTables = EmojiCategory.allCases.map { $0.tableName }
            if let category = category, let index = allTables.firstIndex(of: category.tableName) {
                allTables.remove(at: index)
                allTables.insert(category.tableName, at: 0)
            }
            
            for table in allTables {
                if let emoji = emoji(for: input, from: table) {
                    return emoji
                }
            }
            
            throw TextToEmojiError.noMatchFound
        }
        return try await emojiTask.value
    }
    
    func emoji(for text: String, from tableName: String) -> String? {
        guard
            let path = Bundle.module.path(forResource: tableName, ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return nil  }
        
        let scores = allKeys
            .map { (key: $0, score: stringMatchScoreProvider.provideScore(text, $0)) }
            .sorted(by: { $0.score < $1.score })
        
        guard
            let bestMatch = scores.first,
            Double(bestMatch.score) <= Double(bestMatch.key.count) * 0.2
        else { return nil }
        
        return NSLocalizedString(
            bestMatch.key,
            tableName: tableName,
            bundle: Bundle.module,
            comment: bestMatch.key
        )
    }
}
