import XCTest
@testable import TextToEmoji

final class StringMatchScoreProviderTests: XCTestCase {
    
    var sut: StringMatchScoreProvider!
    
    // MARK: Setup / Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .default
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: Tests
    
    func test_provideScore_withTwoIdenticalStrings_shouldReturnScore() {
        let score = sut.provideScore("apple", "apple")
        
        XCTAssertEqual(score, 0)
    }
    
    func test_provideScore_withTwoAlmostIdenticalStrings_shouldReturnScore() {
        let score = sut.provideScore("apple", "appel")
        
        XCTAssertEqual(score, 2)
    }
}
