import SwiftUI

public struct RepoCommitDetail: View {
    public init(
        urlPath: String,
        localizer: @escaping (Key) -> String = { String(describing: $0) },
        onLoad: @escaping (String) async throws -> CommitDetailItem
    )
    {
        self.localizer  = localizer
        self._model     = StateObject(wrappedValue: Model(onLoad: onLoad, urlPath: urlPath))
    }
    
    @StateObject private var model: Model
    
    // MARK: Properties
    private let localizer: (Key) -> String
    
    public var body: some View {
        VStack {
            Text(localizer(.title))
                .applyTheme(.title)
                .verticalGroup(alignment: .center, spacing: 4) {
                    Text(model.item.sha)
                        .applyTheme(.monospacedRegular)
                }
            
            Form {
                Text(localizer(.author))
                    .applyTheme(.title2)
                    .verticalGroup {
                        Text(model.item.author)
                    }
                
                Text(localizer(.date))
                    .applyTheme(.title2)
                    .verticalGroup {
                        Text(model.item.date, format: .dateTime)
                    }
                
                Section {
                    Text(localizer(.message))
                        .applyTheme(.title2)
                        .verticalGroup(spacing: 24) {
                            Text(model.item.message)
                        }
                }
            }
        }
        .task { await model.loadCommitDetails() }
        .alert(
            localizer(.errorTitle),
            isPresented: $model.showError,
            actions: { Text(localizer(.errorButtonTitle)) },
            message: { Text(localizer(.errorMessage)) }
        )
    }
}

// MARK: Data Models
extension RepoCommitDetail {
    public enum Key {
        case title
        case author
        case date
        case message
        case errorTitle
        case errorMessage
        case errorButtonTitle
    }
    
    @MainActor
    final class Model: ObservableObject {
        init(
            onLoad: @escaping (String) async throws -> CommitDetailItem,
            urlPath: String
        )
        {
            self.onLoad = onLoad
            self.urlPath = urlPath
        }
        
        // MARK: Properties
        @Published var item: CommitDetailItem = .default
        @Published var showError = false
        
        private var onLoad: (String) async throws -> CommitDetailItem
        private var urlPath: String
        
        // MARK: Methods
        func loadCommitDetails() async {
            do { item = try await onLoad(urlPath) }
            catch { showError = true }
        }
    }
}

public struct CommitDetailItem {
    static var `default`: CommitDetailItem = CommitDetailItem(
        author: "",
        date: .now,
        message: "",
        sha: ""
    )
    
    public init(
        author: String,
        date: Date,
        message: String,
        sha: String
    )
    {
        self.author     = author
        self.date       = date
        self.message    = message
        self.sha        = sha
    }
    
    let author: String
    let date: Date
    let message: String
    let sha: String
}

struct RepoCommitDetail_Previews: PreviewProvider {
    static var previews: some View {
        RepoCommitDetail(urlPath: "") { _ in
            CommitDetailItem(
                author: "Brenden Konnagan",
                date: .now,
                message: "Added a cool new feature!",
                sha: UUID().uuidString
            )
        }
    }
}

