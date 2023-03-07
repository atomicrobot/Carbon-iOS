import ARDemoUI
import Foundation

struct Localizers {
    
    
    static func commitDetailViewLocalizer(_ key: RepoCommitDetail.Key) -> String {
        switch key {
        case .author:           return NSLocalizedString("commit_author", comment: "Commit Detial Author")
        case .date:             return NSLocalizedString("commit_date", comment: "Commit Detial Date")
        case .errorButtonTitle: return NSLocalizedString("ok", comment: "Commit Detial Error Button")
        case .errorMessage:     return NSLocalizedString("commit_details_error_description", comment: "Commit Detial Error Message")
        case .errorTitle:       return NSLocalizedString("commit_details_error_title", comment: "Commit Detial Error Title")
        case .message:          return NSLocalizedString("commit_message", comment: "Commit Detial Message")
        case .title:            return NSLocalizedString("commit_details_title", comment: "Commit Detial Title")
        }
    }
    
    static func commitsListLocalizer(_ key: RepoCommits.Key) -> String {
        switch key {
        case .errorMessage: return NSLocalizedString("repository_list_error_description", comment: "Commits List Error Message")
        case .errorOK:      return NSLocalizedString("ok", comment: "Commits List Error Ok Button Title")
        case .errorTitle:   return NSLocalizedString("repository_list_error_title", comment: "Commits List Error Title")
        }
    }
    
    static func loaderLocalizer(_ key: LoaderHUD.Key) -> String {
        switch key {
        case .title:    return NSLocalizedString("loading", comment: "Loading HUD")
        }
    }
    
    static func repositoriesListLocalizer(_ key: RepoList.Key) -> String {
        switch key {
        case .errorMessage: return NSLocalizedString("repository_list_error_description", comment: "Repository List Error Message")
        case .errorOK:      return NSLocalizedString("ok", comment: "Repository List Error Ok Button Title")
        case .errorTitle:   return NSLocalizedString("repository_list_error_title", comment: "Repository List Error Title")
        }
    }
}
