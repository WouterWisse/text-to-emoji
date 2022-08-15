import Foundation

public struct TextToEmoji {
    private let globalDispatchQueue: DispatchQueueExecutor
    private let mainDispatchQueue: DispatchQueueExecutor
    private let stringMatchScoreProvider: StringMatchScoreProvider
    
    public init(
        globalDispatchQueue: DispatchQueueExecutor = DispatchQueue.global(),
        mainDispatchQueue: DispatchQueueExecutor = DispatchQueue.main,
        stringMatchScoreProvider: StringMatchScoreProvider = StringMatchScoreProvider.default
    ) {
        self.globalDispatchQueue = globalDispatchQueue
        self.mainDispatchQueue = mainDispatchQueue
        self.stringMatchScoreProvider = stringMatchScoreProvider
    }
    
    /**
     Will try to match the given text with an emoji.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Chicken" could match 🐔 and 🍗.
     - Passing `.animalsAndNature` will return 🐔
     - Passing `.foodAndDrink` will return 🍗
     
     - Parameters:
        - text: The text that will be matched with an emoji
        - preferredCategory: The preferred category can be useful when looking for specific sets of emoji
        - accuracy: The accuracy used to find the match. The higher the more accurate the results
     
     - Returns: An emoji when a match is found, otherwise nil.
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        accuracy: MatchAccuracy = .medium
    ) -> String? {
        let input = text.lowercased()
        return localizedEmoji(for: input, category: preferredCategory, accuracy: accuracy)
    }
    
    /**
     Will try to match the given text with an emoji asynchronously with completion closure.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Chicken" could match 🐔 and 🍗.
     - Passing `.animalsAndNature` will return 🐔
     - Passing `.foodAndDrink` will return 🍗
     
     - Parameters:
        - text: The text that will be matched with an emoji
        - preferredCategory: The preferred category can be useful when looking for specific sets of emoji
        - accuracy: The accuracy used to find the match. The higher the more accurate the results
        - completion: Closure that will asynchronously receive the matched emoji, or nil if no match is found
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        accuracy: MatchAccuracy = .medium,
        completion: @escaping (_ emoji: String?) -> Void
    ) {
        Task {
            let result = await emoji(for: text, preferredCategory: preferredCategory, accuracy: accuracy)
            completion(result)
        }
    }
    
    /**
     Will try to match the given text with an emoji asynchronously with `async await`.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Chicken" could match 🐔 and 🍗.
     - Passing `.animalsAndNature` will return 🐔
     - Passing `.foodAndDrink` will return 🍗
     
     - Parameters:
        - text: The text that will be matched with an emoji
        - preferredCategory: The preferred category can be useful when looking for specific sets of emoji
        - accuracy: The accuracy used to find the match. The higher the more accurate the results
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        accuracy: MatchAccuracy = .medium
    ) async -> String? {
        await withCheckedContinuation { continuation in
            globalDispatchQueue.executeAsync {
                let input = text.lowercased()
                let emoji = localizedEmoji(for: input, category: preferredCategory, accuracy: accuracy)
                mainDispatchQueue.executeAsync {
                    continuation.resume(returning: emoji)
                }
            }
        }
    }
}

// MARK: Localized Emoji

private extension TextToEmoji {
    func localizedEmoji(
        for text: String,
        category: EmojiCategory?,
        accuracy: MatchAccuracy
    ) -> String? {
        let tableName = category?.tableName ?? "All"
        guard
            let path = Bundle.module.path(forResource: tableName, ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return nil }
        
        let scores = allKeys
            .map { (key: $0, score: stringMatchScoreProvider.provideScore(text, $0)) }
            .sorted(by: { $0.score < $1.score })

        let accuracyPercentage = 1.0 - accuracy.percentage
        
        guard
            let bestMatch = scores.first,
            Double(bestMatch.score) <= Double(bestMatch.key.count) * accuracyPercentage
        else { return nil }
        
        // TODO: Check in All when checking the category failed.
        
        return NSLocalizedString(
            bestMatch.key,
            tableName: tableName,
            bundle: Bundle.module,
            comment: bestMatch.key
        )
    }
}
