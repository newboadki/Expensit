import XCTest
@testable import CoreDataPersistence

final class CoreDataPersistenceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoreDataPersistence().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
