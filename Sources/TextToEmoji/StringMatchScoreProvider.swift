import Foundation

public struct StringMatchScoreProvider {
    var provideScore: (_ text: String, _ possibleMatch: String) -> Int
}

public extension StringMatchScoreProvider {
     static let `default` = StringMatchScoreProvider(
        provideScore: { text, possibleMatch in
            // https://en.wikipedia.org/wiki/Levenshtein_distance
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
    )
}
