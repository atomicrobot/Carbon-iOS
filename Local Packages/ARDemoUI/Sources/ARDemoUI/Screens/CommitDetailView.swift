import SwiftUI

public struct CommitDetailView: View {
    public init(
        urlPath: String,
        localizer: @escaping (Key) -> String = { String(describing: $0) },
        onLoad: @escaping (String) async throws -> CommitDetailItem
    )
    {
        self.localizer = localizer
        self._model = StateObject(wrappedValue: Model(onLoad: onLoad, urlPath: urlPath))
    }
    
    @StateObject private var model: Model
    
    // MARK: Properties
    private let localizer: (Key) -> String
    
    public var body: some View {
        VStack {
            VStack(spacing: 4) {
                Text(localizer(.title))
                    .applyTheme(.title)
                
                Text(model.item.sha)
                    .applyTheme(.monospacedRegular)
            }
            
            Form {
                VStack(alignment: .leading) {
                    Text(localizer(.author))
                        .applyTheme(.title2)
                    
                    Text(model.item.author)
                }
                
                VStack(alignment: .leading) {
                    Text(localizer(.date))
                        .applyTheme(.title2)
                    
                    Text(model.item.date, format: .dateTime)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(localizer(.message))
                            .applyTheme(.title2)
                        
                        Text(model.item.message)
                    }
                }
            }
        }
        .task { await model.loadCommitDetails() }
    }
}

// MARK: Data Models
extension CommitDetailView {
    public enum Key {
        case title
        case author
        case date
        case message
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
        
        private var onLoad: (String) async throws -> CommitDetailItem
        private var urlPath: String
        
        // MARK: Methods
        func loadCommitDetails() async {
            do { item = try await onLoad(urlPath) }
            catch { }
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
        self.author = author
        self.date = date
        self.message = message
        self.sha = sha
    }
    
    let author: String
    let date: Date
    let message: String
    let sha: String
}

struct CommitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommitDetailView(urlPath: "") { _ in
            CommitDetailItem(
                author: "Brenden Konnagan",
                date: .now,
                message: "Added a cool new feature!",
                sha: UUID().uuidString
            )
        }
    }
}

