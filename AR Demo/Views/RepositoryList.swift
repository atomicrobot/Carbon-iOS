import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoryListViewModel()

    var body: some View {
        VStack {
            List(viewModel.repositories) { repo in
                NavigationLink {
                    RepositoryDetailsView(repository: repo)
                } label: {
                    RepositoryRowView(repository: repo)
                }
            }
        }
        .navigationTitle(AppUtils.localizedString("repository_list_title"))
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text.localized(for: "repository_list_error_title"),
                  message: Text.localized(for: "repository_list_error_description"),
                  dismissButton: .default(Text.localized(for: "ok")))
        }
    }
}

struct RepoList_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView()
    }
}
