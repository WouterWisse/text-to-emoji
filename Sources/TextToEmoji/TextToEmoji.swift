import Foundation

public enum TextToEmojiError: Error {
    case noMatchFound
}

public struct TextToEmoji {
    /**
     Will try to match the given text with an emoji.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Shrimp" could match 🦐 and 🍤.
     - Passing `.animalsAndNature` will return 🦐.
     - Passing `.foodAndDrink` will return 🍤.
     - Parameter text: The text that will be matched with an emoji
     - Parameter preferredCategory: The preferred category can be useful when looking for specific sets of emoji
     */
    public static func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil
    ) async throws -> String? {
        try await localizedEmoji(for: text, category: preferredCategory)
    }
}

// MARK: Localized Emoji

private extension TextToEmoji {
    static func localizedEmoji(
        for text: String,
        category: EmojiCategory?
    ) async throws -> String {
        let emojiTask = Task {
            let input = text.prepareString()
            
            let allTables = EmojiCategory.allCases
                .map { $0.tableName }
                .sorted(by: { $0 == category?.tableName && $1 != category?.tableName })
            
            for table in allTables {
                if let emoji = emoji(for: input, from: table) {
                    return emoji
                }
            }
            
            throw TextToEmojiError.noMatchFound
        }
        return try await emojiTask.value
    }
    
    static func emoji(
        for text: String,
        from tableName: String
    ) -> String? {
        let bundle = Bundle.module
        guard
            let path = bundle.path(forResource: tableName, ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return nil  }
        
        // Return an exact match immediately.
        if let exactMatch = allKeys.first(where: { $0 == text }) {
            return NSLocalizedString(
                exactMatch,
                tableName: tableName,
                bundle: bundle,
                comment: exactMatch
            )
        }
        
        // Use Levenshtein Distance to get best match.
        let scores = allKeys
            .map { (key: $0, score: StringMatchScoreProvider.default.provideScore(text, $0)) }
            .sorted(by: { $0.score < $1.score })
        
        // Best match needs to be at least 80% correct.
        guard
            let bestMatch = scores.first,
            Double(bestMatch.score) <= Double(bestMatch.key.count) * 0.2
        else { return nil }
        
        return NSLocalizedString(
            bestMatch.key,
            tableName: tableName,
            bundle: bundle,
            comment: bestMatch.key
        )
    }
}
