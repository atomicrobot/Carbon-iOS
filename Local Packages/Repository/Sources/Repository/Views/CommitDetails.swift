import SwiftUI
import Util

struct CommitDetailsView: View {
    @StateObject private var viewModel: CommitDetailsViewModel

    let commit: Commit

    init(commit: Commit) {
        self.commit = commit
        self._viewModel = StateObject(wrappedValue: CommitDetailsViewModel(commit: commit))
    }

    var body: some View {
        VStack {
            VStack {
                AppUtils.localizedText(for: "commit_details_title")
                    .font(.largeTitle)
                    .padding()

            Text(commit.sha)
                .font(.subheadline)
            }

            Spacer()

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 0) {
                    AppUtils.localizedText(for: "commit_author")
                        .font(.title2)

                    if let login = commit.author?.login {
                        HStack {
                            Text("@\(login)")
                            Spacer()
                        }
                    }

                    HStack {
                        Text(commit.commit.author.name)
                        Spacer()
                    }
                }

                HStack {
                    Text("\(AppUtils.localizedString("commit_date")):")
                        .font(.title2)

                    Text(String(describing: commit.commit.author.date))
                    Spacer()
                }

                HStack {
                    VStack(alignment: .leading) {
                        AppUtils.localizedText(for: "commit_message")
                            .font(.title2)

                        Text(commit.commit.message)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text.localized(for: "commit_details_error_title"),
                  message: Text.localized(for: "commit_details_error_description"),
                  dismissButton: .default(Text.localized(for: "ok")))
        }
    }
}

struct CommitDetails_Previews: PreviewProvider {
    static var previews: some View {
        CommitDetailsView(commit: Commit(sha: "",
                                             commit: CommitDetails(sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                                                   url: "",
                                                                   htmlUrl: "",
                                                                   author: CollaboratorStub(name: "Billy Bob",
                                                                                            email: "billy@gmail.com",
                                                                                            date: Date()),
                                                                   committer: CollaboratorStub(name: "",
                                                                                               email: "",
                                                                                               date: Date()),
                                                                   message: ""),
                                             author: nil,
                                             committer: nil))
    }
}
