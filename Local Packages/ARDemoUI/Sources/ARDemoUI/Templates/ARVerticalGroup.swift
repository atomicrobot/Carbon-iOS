import SwiftUI

struct ARVerticalGroup<Top, Bottom>: View
where Top       : View,
      Bottom    : View
{
    init(
        alignment: HorizontalAlignment  = .leading,
        spacing: CGFloat?               = nil,
        @ViewBuilder top: @escaping () -> Top,
        @ViewBuilder bottom: @escaping () -> Bottom
    )
    {
        self.alignment  = alignment
        self.spacing    = spacing
        
        self.topContent = top
        self.bottomContent = bottom
    }
    
    // MARK: Properties
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    
    // MARK: Content
    private let topContent: () -> Top
    private let bottomContent: () -> Bottom
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            topContent()
            bottomContent()
        }
    }
}

// MARK: View
extension View {
    func verticalGroup<Bottom>(
        alignment: HorizontalAlignment  = .leading,
        spacing: CGFloat?               = nil,
        @ViewBuilder with bottom: @escaping () -> Bottom
    ) -> some View
    where Bottom : View
    {
        ARVerticalGroup(
            alignment: alignment,
            spacing: spacing,
            top: { self },
            bottom: bottom
        )
    }
}

struct ARVerticalGroup_Previews: PreviewProvider {
    static var previews: some View {
        ARVerticalGroup {
            Text("Hello,")
        } bottom: {
            Text("World!")
        }
    }
}
