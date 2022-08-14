import Foundation

public struct TextToEmoji {
    private let globalDispatchQueue: DispatchQueueExecutor
    private let mainDispatchQueue: DispatchQueueExecutor
    
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
        - preferredCategory: The category with which is most likely to have a match
     
     - Returns: An emoji when a match is found, otherwise nil.
     */
    public func emoji(
        for text: String,
        preferredCategory: EmojiCategory? = nil
    ) -> String? {
        let input = text.lowercased()
        return localizedEmoji(for: input, category: preferredCategory)
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
        completion: @escaping (_ emoji: String?) -> Void
    ) {
        globalDispatchQueue.executeAsync {
            let input = text.lowercased()
            let emoji = localizedEmoji(for: input, category: preferredCategory)
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
        category: EmojiCategory?
    ) -> String? {
        let tableName = category?.tableName ?? "All"
        guard
            let path = Bundle.module.path(forResource: tableName, ofType: "strings"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let allKeys = dictionary.allKeys as? [String]
        else { return nil }
        
        let scores = allKeys
            .map { (key: $0, score: matchScore(for: text, possibleMatch: $0)) }
            .sorted(by: { $0.score < $1.score })
        
        // Word must match at least 70%.
        let maxFaultPercentage: Double = 0.3
        
        guard
            let bestMatch = scores.first,
            Double(bestMatch.score) <= Double(bestMatch.key.count) * maxFaultPercentage
        else { return nil }
        
        return NSLocalizedString(
            bestMatch.key,
            tableName: tableName,
            bundle: Bundle.module,
            comment: bestMatch.key
        )
    }
    
    func matchScore(for text: String, possibleMatch: String) -> Int {
        let empty = [Int](repeating: 0, count: possibleMatch.count)
        var distance = [Int](0...possibleMatch.count)

        for (i, characterA) in text.enumerated() {
            var current = [i + 1] + empty
            for (j, characterB) in possibleMatch.enumerated() {
                current[j + 1] = characterA == characterB
                ? distance[j]
                : min(distance[j], distance[j + 1], current[j]) + 1
            }
            distance = current
        }
        return distance.last!
    }
}
