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
        let preferredLanguages = availablePreferredLanguages(in: bundle)
        
        /*
         Many iOS users have their device language set to English, but still have their native language in
         the list of preferred languages. To get the best possible result, we check for all those preferred languages
         as well (if they are supported by this package).
         */
        for language in preferredLanguages {
            guard
                let path = bundle.localizedTablePath(for: tableName, localization: language),
                let dictionary = NSDictionary(contentsOfFile: path),
                let allKeys = dictionary.allKeys as? [String]
            else { continue }
            
            // Return an exact match immediately.
            if let exactMatch = allKeys.first(where: { $0 == text }) {
                return dictionary[exactMatch] as? String
            }
            
            // Use Levenshtein Distance to get best match.
            let scores = allKeys
                .map { (key: $0, score: StringMatchScoreProvider.default.provideScore(text, $0)) }
                .sorted(by: { $0.score < $1.score })
            
            // Best match needs to be at least 80% correct.
            guard
                let bestMatch = scores.first,
                Double(bestMatch.score) <= Double(bestMatch.key.count) * 0.2
            else { continue }
            
            return dictionary[bestMatch.key] as? String
        }
        
        return nil
    }
    
    static func availablePreferredLanguages(in bundle: Bundle) -> [String] {
        let availableLocalizations = bundle.localizations
        let preferredLanguages = Locale.preferredLanguages.compactMap { $0.components(separatedBy: "-").first }
        let availablePreferredLanguages = preferredLanguages.filter { availableLocalizations.contains($0) }
        return availablePreferredLanguages
    }
}

// MARK: Table for Localization

private extension Bundle {
    func localizedTablePath(for tableName: String, localization: String) -> String? {
        path(
            forResource: tableName,
            ofType: "strings",
            inDirectory: "\(localization).lproj",
            forLocalization: localization
        )
    }
}
