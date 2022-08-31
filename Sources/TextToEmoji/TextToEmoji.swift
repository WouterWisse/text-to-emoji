import Foundation

public struct TextToEmoji {
    private let globalDispatchQueue: DispatchQueueExecutor
    private let mainDispatchQueue: DispatchQueueExecutor
    private let stringMatchScoreProvider: StringMatchScoreProvider = .default
    
    public init(
        globalDispatchQueue: DispatchQueueExecutor = DispatchQueue.global(),
        mainDispatchQueue: DispatchQueueExecutor = DispatchQueue.main
    ) {
        self.globalDispatchQueue = globalDispatchQueue
        self.mainDispatchQueue = mainDispatchQueue
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
     
     - Returns: An emoji when a match is found, otherwise nil.
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil
    ) -> String? {
        localizedEmoji(for: text, category: preferredCategory)
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
        - completion: Closure that will asynchronously receive the matched emoji, or nil if no match is found
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        completion: @escaping (_ emoji: String?) -> Void
    ) {
        Task {
            let result = await emoji(for: text, preferredCategory: preferredCategory)
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
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil
    ) async -> String? {
        await withCheckedContinuation { continuation in
            globalDispatchQueue.executeAsync {
                let emoji = localizedEmoji(for: text, category: preferredCategory)
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
        category: EmojiCategory?
    ) -> String? {
        let input = text.lowercased()
        
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
        
        return nil
    }
    
    func emoji(for text: String, from tableName: String) -> String? {
        guard
            let path = Bundle.module.path(forResource: tableName, ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return nil }
        
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
