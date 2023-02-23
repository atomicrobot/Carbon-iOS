import Foundation

enum Config {
    /// Returns a string value from our config file
    /// - Parameter key: The key we want to read
    /// - Returns: String value
    static func stringValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            assertionFailure("Invalid value or undefined key")
            return ""
        }
        return value
    }

    /// Convenience variable to return the name of this app
    static var appName: String {
        stringValue(forKey: "CFBundleName")
    }

    /// Convenience variable to return the bundle ID of this app
    static var bundleId: String {
        stringValue(forKey: "CFBundleIdentifier")
    }

    /// The version information of the app based on the short version and bundle version (i.e. "Version 1.2 (3456)")
    static let versionInfo: String = {
        "\(versionString) (\(bundleVersion))"
    }()

    /// The version string (i.e. "1.2")
    static var versionString: String {
        stringValue(forKey: "CFBundleShortVersionString")
    }

    /// The build number string (i.e. "1234")
    static var bundleVersion: String {
        stringValue(forKey: "CFBundleVersion")
    }
}
