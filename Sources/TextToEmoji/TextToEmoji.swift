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
        - preferredCategory: The category with which is most likely to have a match
     
     - Returns: An emoji when a match is found, otherwise nil.
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        errorMargin: MatchErrorMargin = .medium
    ) -> String? {
        let input = text.lowercased()
        return localizedEmoji(for: input, category: preferredCategory, errorMargin: errorMargin)
    }
    
    /**
     Will try to match the given text with an emoji asynchronously.
     
     The category passed in `preferredCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Chicken" could match 🐔 and 🍗.
     - Passing `.animalsAndNature` will return 🐔
     - Passing `.foodAndDrink` will return 🍗
     
     - Parameters:
        - text: The text that will be matched with an emoji
        - preferredCategory: The category with which is most likely to have a match
        - completion: Closure that will asynchronously receive the matched emoji, or nil if no match is found
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil,
        errorMargin: MatchErrorMargin = .medium,
        completion: @escaping (_ emoji: String?) -> Void
    ) {
        globalDispatchQueue.executeAsync {
            let input = text.lowercased()
            let emoji = localizedEmoji(for: input, category: preferredCategory, errorMargin: errorMargin)
            mainDispatchQueue.executeAsync {
                completion(emoji)
            }
        }
    }
}

// MARK: Localized Emoji

private extension TextToEmoji {
    func localizedEmoji(
        for text: String,
        category: EmojiCategory?,
        errorMargin: MatchErrorMargin
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
        
        guard
            let bestMatch = scores.first,
            Double(bestMatch.score) <= Double(bestMatch.key.count) * errorMargin.percentage
        else { return nil }
        
        return NSLocalizedString(
            bestMatch.key,
            tableName: tableName,
            bundle: Bundle.module,
            comment: bestMatch.key
        )
    }
}
