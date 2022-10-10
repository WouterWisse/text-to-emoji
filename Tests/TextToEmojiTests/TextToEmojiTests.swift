import XCTest
@testable import TextToEmoji

final class TextToEmojiTests: XCTestCase {

    // MARK: Tests
    
    func test_emoji_withValidText_shouldReturnEmoji() async throws {
        let emoji = try await TextToEmoji.emoji(for: "lemon")

        XCTAssertEqual(emoji, "🍋")
    }
    
    func test_emoji_withValidTextWithAdjectives_shouldReturnEmoji() async throws {
        let emoji = try await TextToEmoji.emoji(for: "large organic avocado")
        
        XCTAssertEqual(emoji, "🥑")
    }
    
    func test_emoji_withInvalidText_shouldReturnNil() async throws {
        await XCTAssertThrowsError(try await TextToEmoji.emoji(for: "abc123"))
    }
    
    func test_emoji_withTextAndPreferredCategory_shouldReturnDifferentEmoji() async throws {
        let nature = try await TextToEmoji.emoji(for: "shrimp", preferredCategory: .animalsAndNature)
        let food = try await TextToEmoji.emoji(for: "shrimp", preferredCategory: .foodAndDrink)
        
        XCTAssertEqual(nature, "🦐")
        XCTAssertEqual(food, "🍤")
        XCTAssertNotEqual(nature, food)
    }
}

private extension XCTest {
    func XCTAssertThrowsError<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
