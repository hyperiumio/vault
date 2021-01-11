public var derivedKey: String { "DerivedKey" }

#if os(iOS)
public var appGroup: String { "group.io.hyperium.vault" }
#endif

#if os(macOS)
public var appGroup: String { "HX3QTQLX65.io.hyperium.vault" }
#endif
