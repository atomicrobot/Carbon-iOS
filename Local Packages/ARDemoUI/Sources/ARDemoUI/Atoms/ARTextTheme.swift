import SwiftUI

struct ARTextTheme {
    let font: Font
    let foregroundColor: Color
}

extension View {
    func applyTheme(
        _ theme: ARTextTheme
    ) -> some View
    {
        self
            .font(theme.font)
            .foregroundColor(theme.foregroundColor)
    }
}

extension ARTextTheme {
    static var largeTitle: ARTextTheme = ARTextTheme(
        font: .system(size: 36, weight: .heavy, design: .monospaced),
        foregroundColor: ColorResource.textOne
    )
}
