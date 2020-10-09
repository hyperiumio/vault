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
                switch completion {
                case .finished:
                    didComplete.fulfill()
                case .failure:
                    XCTFail()
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
        .sink { completion in
            switch completion {
            case .finished:
                XCTFail()
            case .failure:
                didComplete.fulfill()
            }
        } receiveValue: {
            XCTFail()
        }
        .store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: expectations, timeout: .infinity)
        XCTAssertEqual(result, .completed)
    }
    
}
