import Foundation
// swiftlint:disable identifier_name
// MARK: - Network case section
enum NetworkRouter {
    // MARK: Auth cases
    case assets,
         asset(id: String),
         history(id: String)
    
    var baseUrl: String {
        "https://api.coincap.io/v2/"
    }
    
    // MARK: - String url section
    var stringUrl: String {
        switch self {
        // MARK: Auth urls
        case .assets:
            return baseUrl + Routes.Assets.assets
        case .asset(let id):
            return baseUrl + Routes.Assets.assets + "/\(id)/"
        case .history(let id):
            return baseUrl + Routes.Assets.assets + "/\(id)/" + Routes.Assets.history
        }
    }
    
    func getUrl() -> String {
        guard let url = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            assertionFailure("Failed to unwrap url")
            return ""
        }
        return url
    }
}
