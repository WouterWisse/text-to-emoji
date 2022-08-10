import XCTest
@testable import TextToEmoji

final class TextToEmojiTests: XCTestCase {
    
    var sut: TextToEmoji!
    
    // MARK: Setup / Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TextToEmoji()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: Tests
    
    func test_emojiForText_withValidText_shouldReturnEmoji() {
        let emoji = sut.emoji(for: "lemon")
        
        XCTAssertEqual(emoji, "🍋")
    }
    
    func test_emojiForText_withInvalidText_shouldReturnNil() {
        let emoji = sut.emoji(for: "abc123")
        
        XCTAssertNil(emoji)
    }
}
