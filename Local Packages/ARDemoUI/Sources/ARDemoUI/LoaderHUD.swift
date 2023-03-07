import SwiftUI

/// A view to indicate a loading status
public struct LoaderHUD: View {
    public enum Key {
        case title
    }
    
    public init(
        localizer: @escaping (Key) -> String = { String(describing: $0) }
    )
    {
        self.localizer = localizer
    }
    
    private var localizer: (Key) -> String
    
    public var body: some View {
        VStack {
            Text(localizer(.title))
                .applyTheme(.largeTitle)
                .frame(width: 200, height: 200)
                .background(
                    ColorResource.elevationOne,
                    in: RoundedRectangle(cornerRadius: 24)
                )
                .shadow(radius: 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }
}

extension LoaderHUD {
    @ViewBuilder
    var screenBackground: some View {
        ColorResource
            .elevationTwo
            .opacity(0.25)
            .edgesIgnoringSafeArea(.all)
    }
}

struct LoaderHUD_Previews: PreviewProvider {
    static var previews: some View {
        LoaderHUD()
    }
}
