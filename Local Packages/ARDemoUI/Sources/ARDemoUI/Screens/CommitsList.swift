import SwiftUI

public struct CommitsList: View {
    public init(
        urlPath: String,
        onLoad: @escaping (String) async throws -> [CommitsListDataItem],
        localizer: @escaping (Key) -> String = { String(describing: $0) }
    )
    {
        self.localizer = localizer
        self._model = StateObject(wrappedValue: Model(urlPath: urlPath, onLoad: onLoad))
    }
    
    // MARK: Properties
    @StateObject private var model: Model
    
    private let localizer: (Key) -> String
    
    public var body: some View {
        List(model.commits, rowContent: commitRowContent(_:))
            .task { await model.loadCommits() }
            .alert(
                localizer(.errorTitle),
                isPresented: $model.showError,
                actions: { Text(localizer(.errorOK)) },
                message: { Text(localizer(.errorMessage)) }
            )
    }
    
    @ViewBuilder
    private func commitRowContent(_ data: CommitsListDataItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(data.sha)
                .applyTheme(.monospacedRegular)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.5)
            
            Text(data.message)
                .applyTheme(.subheadline)
                .lineLimit(2)
                .truncationMode(.middle)
        }
    }
}

// MARK: Data Models
extension CommitsList {
    public enum Key {
        case errorMessage
        case errorOK
        case errorTitle
    }
    
    @MainActor
    final class Model: ObservableObject {
        init(
            urlPath: String,
            onLoad: @escaping (String) async throws -> [CommitsListDataItem]
        )
        {
            self.onLoad = onLoad
            self.urlPath = urlPath
        }
        
        // MARK: Properties
        @Published var commits: [CommitsListDataItem] = []
        @Published var showError = false
        
        private var onLoad: (String) async throws -> [CommitsListDataItem]
        private var urlPath: String
        
        // MARK: Functions
        func loadCommits() async {
            do { commits = try await onLoad(urlPath) }
            catch { showError = true }
        }
    }
}

struct CommitsList_Previews: PreviewProvider {
    static var previews: some View {
        CommitsList(
            urlPath: "",
            onLoad: { _ in [
                CommitsListDataItem(
                    sha: UUID().uuidString,
                    message: "This is one of the coolest commits eva."
                )
            ]}
        )
    }
}

public struct CommitsListDataItem: Identifiable {
    public init(
        sha: String,
        message: String
    )
    {
        self.message = message
        self.sha = sha
    }
    
    let sha: String
    let message: String
    
    public var id: String { sha + message }
}
