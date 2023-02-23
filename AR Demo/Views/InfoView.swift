
import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(Config.appName)
            Text(Config.bundleId)
            Text(Config.versionInfo)
        }
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
