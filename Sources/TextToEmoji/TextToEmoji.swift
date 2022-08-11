import Foundation

public struct TextToEmoji {
    /**
     Tries to match the given text with an emoji.
     
     The category passed in `highPriorityCategory` will be given a higher priorty when multiple
     emoji's match the given `text`. For example: "Chicken" could match 🐔 and 🍗.
     - Passing `.animalsAndNature` will return 🐔
     - Passing `.foodAndDrink` will return 🍗
     
     - Parameters:
        - text: The text that will be matched with an emoji
        - highPriorityCategory: The category with which is most likely to have a match
     
     - Returns: An emoji when a match is found, otherwise nil.
     */
    public func emoji(
        for text: String,
        highPriorityCategory: EmojiCategory? = nil
    ) -> String? {
        let input = text.lowercased()
        
        let emoji = NSLocalizedString(
            input,
            tableName: highPriorityCategory?.stringsFileName,
            bundle: Bundle.module,
            value: input,
            comment: input
        )
        
        guard emoji != input else { return nil }
        return emoji
    }
}
