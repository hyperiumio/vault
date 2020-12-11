private var appBundle: String { "io.hyperium.vault" }
public var cloudContainer: String { "group.\(appBundle).default" }
public var derivedKey: String { "DerivedKey" }

#if os(iOS)
public var appGroup: String { "group.\(appBundle)" }
#endif

#if os(macOS)
public var appGroup: String { "HX3QTQLX65.\(appBundle)" }
#endif
