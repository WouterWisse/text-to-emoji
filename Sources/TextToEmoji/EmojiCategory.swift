import Foundation

public enum EmojiCategory {
    /// 😃 Smileys & People - Emojis for smileys, people, families, hand gestures, clothing and accessories.
    case smileysAndPeople
    /// 🐻 Animals & Nature - Emojis for animals, nature, and weather.
    case animalsAndNature
    /// 🍔 Food & Drink - Emojis for fruit, vegetables, meals, beverages and utensils.
    case foodAndDrink
    /// ⚽ Activity - Emojis for sports, music, the arts, hobbies and other activities.
    case activity
    /// 🚀 Travel & Places - Emojis for varied scenes, locations, buildings and modes of transport.
    case travelAndPlaces
    /// 💡 Objects - Emojis for household items, celebrations, stationery and miscellaneous objects.
    case objects
    /// 💕 Symbols - Heart emojis, clocks, arrows, signs and shapes.
    case symbols
    /// 🎌 Flags - Country flag emojis.
    case flags
    
    var stringsFileName: String {
        switch self {
        case .smileysAndPeople: return "SmileysAndPeople.strings"
        case .animalsAndNature:  return "AnimalsAndNature.strings"
        case .foodAndDrink:  return "FoodAndDrink.strings"
        case .activity:  return "Activity.strings"
        case .travelAndPlaces:  return "TravelAndPlaces.strings"
        case .objects:  return "Objects.strings"
        case .symbols:  return "Symbols.strings"
        case .flags:  return "Flags.strings"
        }
    }
}
