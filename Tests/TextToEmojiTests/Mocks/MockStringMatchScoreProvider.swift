import Foundation
@testable import TextToEmoji

extension StringMatchScoreProvider {
    static let mock: (MockStringMatchScoreProvider?) -> StringMatchScoreProvider = { mock in
        guard let mock = mock else {
            return StringMatchScoreProvider(provideScore: { _, _ in fatalError("Mock not implemented.") })
        }
        
        return StringMatchScoreProvider(
            provideScore: mock.provideScore
        )
    }
}

final class MockStringMatchScoreProvider {

    var invokedProvideScore = false
    var invokedProvideScoreCount = 0
    var invokedProvideScoreParameters: (text: String, possibleMatch: String)?
    var invokedProvideScoreParametersList = [(text: String, possibleMatch: String)]()
    var stubbedProvideScoreResult: Int! = 0

    func provideScore(_ text: String, _ possibleMatch: String) -> Int {
        invokedProvideScore = true
        invokedProvideScoreCount += 1
        invokedProvideScoreParameters = (text, possibleMatch)
        invokedProvideScoreParametersList.append((text, possibleMatch))
        return stubbedProvideScoreResult
    }
}
