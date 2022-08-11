import Foundation

public struct TextToEmoji {
    /**
     Tries to match the given text with an emoji.
     
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
        
        var emoji: String?
        
        // Try to find a match in the preferred category.
        if let preferredCategory = preferredCategory {
            emoji = NSLocalizedString(
                input,
                tableName: preferredCategory.stringsFileName,
                bundle: Bundle.module,
                value: input,
                comment: input
            )
        }
        
        // Try to find a match in default Localizable.strings.
        if emoji == nil || emoji == input {
            emoji = NSLocalizedString(input, bundle: Bundle.module, value: input, comment: input)
        }
        
        guard emoji != input, emoji?.isEmpty == false else { return nil }
        return emoji
    }
}
