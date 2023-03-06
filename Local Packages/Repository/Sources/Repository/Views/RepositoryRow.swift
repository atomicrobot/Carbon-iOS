import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.title2)

            Text(repository.description ?? "")
                .font(.footnote)
                .lineLimit(2)
        }
    }
}

struct RepositoryRow_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryRowView(repository: Repository(id: 1234,
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
