import XCTest
@testable import CoreExpenses

final class CoreExpensesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoreExpenses().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
