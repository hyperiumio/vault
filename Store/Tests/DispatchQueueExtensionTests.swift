import Combine
import Foundation
import XCTest
@testable import Store

class DispatchQueueExtensionTests: XCTestCase {
    
    let queue = DispatchQueue(label: "")
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        subscriptions.removeAll()
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func testFutureNotOnMainQueue() {
        let didComplete = XCTestExpectation()
        let expectations = [didComplete]
        
        _ = queue.future {
            XCTAssertFalse(Thread.isMainThread)
            didComplete.fulfill()
        }
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testFutureSuccess() {
        let didComplete = XCTestExpectation()
        let expectations = [didComplete]
        
        queue.future { "foo" }
            .sink { completion in
                if case .finished = completion {
                    didComplete.fulfill()
                }
            } receiveValue: { value in
                XCTAssertEqual(value, "foo")
            }
            .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
    func testFutureFailure() {
        let didComplete = XCTestExpectation()
        let expectations = [didComplete]
        
        queue.future {
            throw NSError()
        }
        .catch { error in
            return Just("foo")
        }
        .sink { completion in
            if case .finished = completion {
                didComplete.fulfill()
            }
        } receiveValue: { value in
            XCTAssertEqual(value, "foo")
        }
        .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
}
