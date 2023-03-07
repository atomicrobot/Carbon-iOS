import SwiftUI

public struct RepositoryList: View {
    public enum Key {
        case errorMessage
        case errorOK
        case errorTitle
    }
    
    @MainActor
    final class Model: ObservableObject {
        init(
            onLoad: @escaping () async throws -> [RepostioryListDataItem]
        )
        {
            self.onLoad = onLoad
        }
        
        private var onLoad: () async throws -> [RepostioryListDataItem]
        
        // MARK: Properties
        @Published
        var items: [RepostioryListDataItem] = []
        
        @Published
        var showError = false
        
        // MARK: Methods
        func loadItems() async {
            do { items = try await onLoad() }
            catch { showError = true }
        }
    }
    
    public init(
        onLoad: @escaping () async throws -> [RepostioryListDataItem],
        localizer: @escaping (Key) -> String = { String(describing: $0) }
    )
    {
        self.localizer = localizer
        self._model = StateObject(wrappedValue: Model(onLoad: onLoad))
    }
    
    // MARK: Properties
    @StateObject private var model: Model
    
    private var localizer: (Key) -> String
    
    public var body: some View {
        List(model.items, rowContent: rowContent(_:))
            .task { await model.loadItems() }
            .alert(
                localizer(.errorTitle),
                isPresented: $model.showError,
                actions: { Text(localizer(.errorOK)) },
                message: { Text(localizer(.errorMessage)) }
            )
    }
}

extension RepositoryList {
    @ViewBuilder
    private func rowContent(
        _ item: RepostioryListDataItem
    ) -> some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .applyTheme(.title2)
            
            Text(item.description)
                .applyTheme(.footnote)
        }
    }
}

public struct RepostioryListDataItem: Identifiable {
    public init(
        name: String,
        description: String?
    )
    {
        self.description = description ?? ""
        self.name        = name
    }
    
    let name: String
    let description: String
    
    public var id: String { name + description }
}

struct RepositoryList_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryList(onLoad: { [
            RepostioryListDataItem(
                name: "Carbon-iOS",
                description: "A sample project."
            )
        ] })
    }
}
