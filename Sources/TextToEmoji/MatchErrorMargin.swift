import Foundation

public enum MatchErrorMargin {
    /// 20% room for typo's, which means that the String must match at least 80%. Very accurate.
    case low
    /// 30% room for typo's, which means that the String must match at least 70%. Accurate.
    case medium
    /// 50% room for typo's, which means that the String must match at least 50%. Not very accurate.
    case high
    /// Custom value from `0.0 - 1.0`. Higher number leaves more room for error, thus less accurate results.
    case custom(value: Double)
    
    /// Percentage based error margin means that more typo's are allowed in longer Strings.
    var percentage: Double {
        switch self {
        case .low:
            return 0.2
        case .medium:
            return 0.3
        case .high:
            return 0.5
        case .custom(let value):
            return value
        }
    }
}
