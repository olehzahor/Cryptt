import Foundation

extension Encodable {
    func jsonBody() -> [String: Any]? {
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(self) else { return nil }
        let body = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
        return body
    }
}
