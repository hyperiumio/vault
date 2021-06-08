import XCTest
@testable import Persistence

class ReadingContextTests: XCTestCase {
    
    func testReadingContextInit() {
        let url = URL(fileURLWithPath: "foo")
        let locator = StoreItemLocator(url: url)
        let context = ReadingContext(locator)
        
        XCTAssertEqual(context.itemLocator, locator)
    }
    /*
    func testReadingContextInvalidFileHandle() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleFailure = { _ in
            throw NSError()
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleFailure))
    }
    
    func testReadingContextInvalidStartIndex() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .success(()), readResult: .success(Data()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: -1 ..< 1, fileHandle: fileHandleStub))
    }
    
    func testReadingContextSeekFailure() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .failure(NSError()), readResult: .success(Data()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleStub))
    }
    
    func testReadingContextReadFailure() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .success(()), readResult: .failure(NSError()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleStub))
    }
 */
    
}
