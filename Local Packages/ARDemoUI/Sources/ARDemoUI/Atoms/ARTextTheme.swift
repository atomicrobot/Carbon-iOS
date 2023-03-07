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
    static var footnote: ARTextTheme = ARTextTheme(
        font: .footnote,
        foregroundColor: ColorResource.textOne
    )
    
    static var largeTitle: ARTextTheme = ARTextTheme(
        font: .system(size: 36, weight: .heavy, design: .monospaced),
        foregroundColor: ColorResource.textOne
    )
    
    static var monospacedRegular: ARTextTheme = ARTextTheme(
        font: .system(.footnote, design: .monospaced, weight: .semibold),
        foregroundColor: ColorResource.textOne
    )
    
    static var subheadline: ARTextTheme = ARTextTheme(
        font: .subheadline,
        foregroundColor: ColorResource.textOne
    )
    
    static var title: ARTextTheme = ARTextTheme(
        font: .system(.title, weight: .bold),
        foregroundColor: ColorResource.textOne
    )
    
    static var title2: ARTextTheme = ARTextTheme(
        font: .system(.title2, weight: .semibold),
        foregroundColor: ColorResource.textOne
    )
}
