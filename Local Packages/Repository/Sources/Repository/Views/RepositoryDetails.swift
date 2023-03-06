import SwiftUI

struct RepositoryDetailsView: View {
    @StateObject private var viewModel: RepositoryDetailsViewModel
    @State private var activeCommit: Commit?

    private let repository: Repository

    init(repository: Repository) {
        self._viewModel = StateObject(wrappedValue: RepositoryDetailsViewModel(repository: repository))
        self.repository = repository
    }

    var body: some View {
        VStack {
            List(viewModel.commits) { commit in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(commit.sha)
                            .lineLimit(1)

                        Text(commit.commit.message)
                            .font(.subheadline)
                            .lineLimit(2)
                    }

                    Spacer()

                    HStack {
                        Image(systemName: "chevron.right")
                    }
                }
                .onTapGesture {
                    activeCommit = commit
                }
            }
        }
        .navigationTitle(repository.name)
        .sheet(item: $activeCommit, onDismiss: { }, content: { commit in
            CommitDetailsView(commit: commit)
        })
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text.localized(for: "commit_list_error_title"),
                  message: Text.localized(for: "commit_list_error_description"),
                  dismissButton: .default(Text.localized(for: "ok")))
        }
    }
}

struct RepositoryDetails_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailsView(repository: Repository(id: 1234,
                                                     name: "my-favorite-repo",
                                                     fullName: "atomicrobot/my-favorite-repo",
                                                     private: false,
                                                     htmlUrl: "",
                                                     description: "Some awesome stuff going down here",
                                                     fork: false,
                                                     url: "",
                                                     commitsUrl: "",
                                                     visibility: "public"))
    }
}
