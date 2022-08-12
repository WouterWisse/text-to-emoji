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
    
    var tableName: String {
        switch self {
        case .smileysAndPeople: return "SmileysAndPeople"
        case .animalsAndNature:  return "AnimalsAndNature"
        case .foodAndDrink:  return "FoodAndDrink"
        case .activity:  return "Activity"
        case .travelAndPlaces:  return "TravelAndPlaces"
        case .objects:  return "Objects"
        case .symbols:  return "Symbols"
        case .flags:  return "Flags"
        }
    }
}
