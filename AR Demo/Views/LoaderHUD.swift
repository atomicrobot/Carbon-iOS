import SwiftUI

struct LoaderHUDView: View {
    var body: some View {
        VStack {
            HStack {
                AppUtils.localizedText(for: "loading")
                    .font(.system(size: 36, weight: .heavy, design: .monospaced))
            }
            .frame(width: 200, height: 200)
            .background(Color("color-2"))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("color-1")
                        .opacity(0.25)
                        .edgesIgnoringSafeArea(.all))
    }
}

struct LoaderHUD_Previews: PreviewProvider {
    static var previews: some View {
        LoaderHUDView()
    }
}
