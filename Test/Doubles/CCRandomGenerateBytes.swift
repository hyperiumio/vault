import Foundation

typealias CCRNGStatus = Int32

let kCCSuccess = Int32(0)

func CCRandomGenerateBytes(_ bytes: UnsafeMutableRawPointer!, _ count: Int) -> CCRNGStatus {
    let configuration = CCRandomGenerateBytesConfiguration.current!
    let bytes = UnsafeMutableRawBufferPointer(start: bytes, count: count)
    configuration.bytes.copyBytes(to: bytes)
    return configuration.returnValue
}


struct CCRandomGenerateBytesConfiguration {
    
    let returnValue: CCRNGStatus
    let bytes: [UInt8]

    static func failure() -> CCRandomGenerateBytesConfiguration {
        let bytes = [UInt8]()
        return CCRandomGenerateBytesConfiguration(returnValue: -1, bytes: bytes)
    }

    static func zeroCount() -> CCRandomGenerateBytesConfiguration {
        let bytes = [UInt8]()
        return CCRandomGenerateBytesConfiguration(returnValue: kCCSuccess, bytes: bytes)
    }

    static func withBytes(_ bytes: [UInt8]) -> CCRandomGenerateBytesConfiguration {
        return CCRandomGenerateBytesConfiguration(returnValue: kCCSuccess, bytes: bytes)
    }
    
}

extension CCRandomGenerateBytesConfiguration {
    
    static var current: CCRandomGenerateBytesConfiguration?
    
}
//Test/Misc/Info.plist
