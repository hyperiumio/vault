public var appBundleID: String { "io.hyperium.vault" }
public var cloudContainerID: String { "group.\(appBundleID).default" }

#if os(iOS)
public var appGroup: String { "group.\(appBundleID)" }
#endif

#if os(macOS)
public var appGroup: String { "HX3QTQLX65.\(appBundleID)" }
#endif
