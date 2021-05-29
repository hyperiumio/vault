import XCTest

extension XCTestCase {
    
    public func asyncTest(file: StaticString = #file, line: Int = #line, test: @escaping () async throws -> ()) {
        let expectation = XCTestExpectation()
        detach {
            do {
                try await test()
                expectation.fulfill()
            } catch {
                XCTFail("Error thrown while executing async function @ \(file):\(line): \(error)")
            }
        }
        XCTWaiter().wait(for: [expectation], timeout: .infinity)
    }
    
}
