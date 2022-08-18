import Foundation

extension TextToEmoji {
    public enum MatchConfidence: Equatable {
        /// String must match at least 50%. Not very accurate.
        case low
        /// String must match at least 70%. Accurate.
        case medium
        /// String must match at least 80%. Very accurate.
        case high
        /// String must match 100%. Most accurate.
        case perfect
        /// Custom value from `0.0 - 1.0`. The higher the number, the more accurate results.
        case custom(value: Double)
        
        /// Percentage based accuracy means that more differences are allowed in longer Strings.
        var percentage: Double {
            switch self {
            case .low:
                return 0.5
            case .medium:
                return 0.7
            case .high:
                return 0.8
            case .perfect:
                return 1.0
            case .custom(let value):
                return value
            }
        }
    }
}
