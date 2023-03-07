import SwiftUI

public struct AppInfo: View {
    public init(
        item: AppInfoItem
    )
    {
        self.item = item
    }
    
    // MARK: Properties
    private let item: AppInfoItem
    
    public var body: some View {
        VStack {
            Text("App Info")
                .applyTheme(.title)
            
            Form {
                VStack(alignment: .leading, spacing: 4) {
                    Text("App Name")
                        .applyTheme(.title2)
                    
                    Text(item.appName)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bundle ID:")
                        .applyTheme(.title2)
                    
                    Text(item.bundleID)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Version Info")
                        .applyTheme(.title2)
                    
                    Text(item.appVersion)
                }
            }
        }
    }
}

// MARK: - Data Models
public struct AppInfoItem {
    public init(
        appName: String,
        appVersion: String,
        bundleID: String
    )
    {
        self.appName    = appName
        self.appVersion = appVersion
        self.bundleID   = bundleID
    }
    
    let appName: String
    let appVersion: String
    let bundleID: String
}

struct AppInfo_Previews: PreviewProvider {
    static var previews: some View {
        AppInfo(item: AppInfoItem(
            appName: "AR Demo",
            appVersion: "1.0.1",
            bundleID: "com.atomicrobot.com"
        ))
    }
}
