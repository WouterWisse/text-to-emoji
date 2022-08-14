import XCTest
@testable import TextToEmoji

final class TextToEmojiTests: XCTestCase {
    
    var sut: TextToEmoji!
    var mockDispatchQueueExecutor: MockDispatchQueueExecutor!
    
    // MARK: Setup / Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDispatchQueueExecutor = MockDispatchQueueExecutor()
        mockDispatchQueueExecutor.shouldInvokeExecuteAsyncWork = true
        
        sut = TextToEmoji(
            globalDispatchQueue: mockDispatchQueueExecutor,
            mainDispatchQueue: mockDispatchQueueExecutor
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockDispatchQueueExecutor = nil
        sut = nil
    }
    
    // MARK: Tests
    
    func test_emoji_withValidText_shouldReturnEmoji() {
        let emoji = sut.emoji(for: "lemon")
        
        XCTAssertEqual(emoji, "🍋")
    }
    
    func test_emoji_withInvalidText_shouldReturnNil() {
        let emoji = sut.emoji(for: "abc123")
        
        XCTAssertNil(emoji)
    }
    
    func test_emoji_withTextAndPreferredCategory_shouldReturnDifferentEmoji() {
        let emoji = sut.emoji(for: "chicken")
        let preferredEmoji = sut.emoji(for: "chicken", preferredCategory: .foodAndDrink)
        
        XCTAssertEqual(emoji, "🐔")
        XCTAssertEqual(preferredEmoji, "🍗")
        XCTAssertNotEqual(emoji, preferredEmoji)
    }
    
    func test_emoji_withTextAndCompletion_shouldReturnEmoji() {
        sut.emoji(for: "tomato", completion: { emoji in
            XCTAssertEqual(emoji, "🍅")
        })
    }
}
