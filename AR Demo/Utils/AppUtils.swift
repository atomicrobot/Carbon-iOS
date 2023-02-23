
import SwiftUI

/// Utils struct to put code that doesn't have a great home anywhere else. I know some people hate having a "utils"
/// class or whatever, but I don't mind it. Plus, you can test these functions pretty easily.
struct AppUtils {
    /// Helper function to return a localized string based on key
    /// - Parameter key: The string key
    /// - Returns: String
    static func localizedString(_ key: String) -> String {
        NSLocalizedString(key, tableName: "Localizable", bundle: .main, comment: "")
    }

    /// Helper function to return a Text view with localized string based on key
    /// - Parameter key: The string key
    /// - Returns: `Text`
    static func localizedText(for key: String) -> some View {
        Text(LocalizedStringKey(key), tableName: "Localizable", bundle: .main, comment: "")
    }
}
