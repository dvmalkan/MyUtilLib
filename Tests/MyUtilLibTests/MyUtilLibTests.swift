import Testing
@testable import MyUtilLib

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let testString = myUtilFunc ()
    #expect (testString == "test")
}
