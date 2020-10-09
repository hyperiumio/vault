import XCTest
@testable import Store

class FileReaderTests: XCTestCase {
    
    func testIsInvalidAfterUsage() throws {
        let mock = FileHandleMock()
        let reader = try FileReader.read(from: mock) { reader in reader }
        
        let expression = {
            try reader.bytes(in: 0 ..< 1)
        }
        
        XCTAssertThrowsError(try expression())
    }
    
    func testInvalidRange() {
        let mock = FileHandleMock()
        
        let expression = {
            _ = try FileReader.read(from: mock) { reader in
                try reader.bytes(in: -1 ..< 0)
            }
        }

        XCTAssertThrowsError(try expression())
    }
    
    func testSeekThrows() {
        let output = FileHandleMock.Output(seekToOffsetThrows: true)
        let mock = FileHandleMock(output: output)
        
        let expression = {
            _ = try FileReader.read(from: mock) { reader in
                try reader.bytes(in: 0 ..< 1)
            }
        }
        
        XCTAssertThrowsError(try expression())
    }
    
    func testReadThrows() {
        let output = FileHandleMock.Output(readUpToCountThrows: true)
        let mock = FileHandleMock(output: output)
        
        let expression = {
            _ = try FileReader.read(from: mock) { reader in
                try reader.bytes(in: 0 ..< 1)
            }
        }
        
        XCTAssertThrowsError(try expression())
    }
    
    func testReadNoData() {
        let output = FileHandleMock.Output(readUpToCount: nil)
        let mock = FileHandleMock(output: output)
        
        let expression = {
            _ = try FileReader.read(from: mock) { reader in
                try reader.bytes(in: 0 ..< 1)
            }
        }
        
        XCTAssertThrowsError(try expression())
    }
    
    func testBytesInRange() throws {
        let expectation = [
            FileHandleMock.Event.seek(offset: 1),
            FileHandleMock.Event.read(count: 2)
        ]
        let expectedData = Data(0 ... UInt8.max)
        let output = FileHandleMock.Output(readUpToCount: expectedData)
        let mock = FileHandleMock(expectation: expectation, output: output)
        
        let data = try FileReader.read(from: mock) { reader in
            try reader.bytes(in: 1 ..< 3)
        }
        
        XCTAssertEqual(data, expectedData)
        mock.validate()
    }
    
}

class FileHandleMock: FileHandleRepresentable {
    
    private let expectation: [Event]
    private let output: Output
    private var recorded = [Event]()
    
    init(expectation: [Event] = [], output: Output = Output()) {
        self.expectation = expectation
        self.output = output
    }
    
    func seek(toOffset offset: UInt64) throws {
        if output.seekToOffsetThrows {
            throw NSError()
        }
        
        let call = Event.seek(offset: offset)
        recorded.append(call)
    }
    
    func read(upToCount count: Int) throws -> Data? {
        if output.readUpToCountThrows {
            throw NSError()
        }
        
        let call = Event.read(count: count)
        recorded.append(call)
        
        return output.readUpToCount
    }
    
    func validate() {
        XCTAssertEqual(recorded, expectation)
    }
    
}

extension FileHandleMock {
    
    enum Event: Equatable {
        
        case seek(offset: UInt64)
        case read(count: Int)
        
    }
    
    struct Output {
        
        let seekToOffsetThrows: Bool
        let readUpToCountThrows: Bool
        let readUpToCount: Data?
        
        init(seekToOffsetThrows: Bool = false, readUpToCountThrows: Bool = false, readUpToCount: Data? = Data()) {
            self.seekToOffsetThrows = seekToOffsetThrows
            self.readUpToCountThrows = readUpToCountThrows
            self.readUpToCount = readUpToCount
        }
        
    }
    
}
