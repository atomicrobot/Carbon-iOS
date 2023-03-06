import SwiftUI

public extension Text {
    /// Helpful function to return a localized string for a Text field
    /// - Parameter key: The key to translate
    /// - Returns: Text view
    static func localized(for key: String) -> Text {
        Text(LocalizedStringKey(key), tableName: "Localizable", bundle: .main)
    }
}
