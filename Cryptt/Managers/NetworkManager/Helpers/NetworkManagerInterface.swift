import Foundation
import Alamofire

public enum APIResponse<Response> {
    case success(Response)
    case failure(CRError)
}

public protocol NetworkManagerInterface {
    func callApi<T: Decodable>(url: URL,
                               body: [String: Any]?,
                               method: HTTPMethod,
                               headers: Headers?,
                               completion: @escaping ((APIResponse<T>) -> Void))
}

extension NetworkManagerInterface {
    func callApi<T: Decodable>(url: URL,
                               body: Encodable?,
                               method: HTTPMethod,
                               headers: Headers?,
                               completion: @escaping ((APIResponse<T>) -> Void)) {
        callApi(url: url, body: body?.jsonBody(), method: method, headers: headers, completion: completion)
    }
}
