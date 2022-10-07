import XCTest
@testable import TextToEmoji

final class StringPreparationTests: XCTestCase {
    
    // MARK: Tests
    
    func test_perpareString_withPrefixWhitespace_shouldRemoveWhitespace() {
        let string = " avocado".prepareString()
        
        XCTAssertEqual(
            string, "avocado",
            "Expected `string` to equal 'avocado', but it is `\(string)`"
        )
    }
    
    func test_perpareString_withSiffoxWhitespace_shouldRemoveWhitespace() {
        let string = "avocado ".prepareString()
        
        XCTAssertEqual(
            string, "avocado",
            "Expected `string` to equal 'avocado', but it is `\(string)`"
        )
    }
    
    func test_perpareString_withAdjective_shouldRemoveAdjective() {
        let string = "organic avocado".prepareString()
        
        XCTAssertEqual(
            string, "avocado",
            "Expected `string` to equal 'avocado', but it is `\(string)`"
        )
    }
    
    func test_perpareString_withMultipleAdjectives_shouldRemoveAdjective() {
        let string = "huge large organic avocado".prepareString()
        
        XCTAssertEqual(
            string, "avocado",
            "Expected `string` to equal 'avocado', but it is `\(string)`"
        )
    }
}
