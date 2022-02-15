import Foundation
import Alamofire

public final class NetworkManager: NetworkManagerInterface {
    private var session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    public func callApi<T: Decodable>(url: URL,
                                      body: [String: Any]?,
                                      method: HTTPMethod,
                                      headers: Headers?,
                                      completion: @escaping ((APIResponse<T>) -> Void)) {
        session.request(url,
                        method: method,
                        parameters: body,
                        encoding: method == .get ? URLEncoding(destination: .queryString) : JSONEncoding.prettyPrinted,
                        headers: getHeaders(headers))
            .responseData { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let data):
                    self.decode(data: data,
                                response: response,
                                completion: completion)
                case .failure(_):
                    completion(.failure(CRError(response)))
                }
            }
    }
    
    private func getHeaders(_ ticHeaders: Headers?) -> HTTPHeaders? {
        guard let headers = ticHeaders else {
            return nil
        }
        return HTTPHeaders(headers)
    }
    
    private func decode<T: Decodable>(data: Data,
                                      response: AFDataResponse<Data>,
                                      completion: @escaping ((APIResponse<T>) -> Void)) {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            completion(.success(object))
        } catch {
            completion(.failure(CRError(message: error.debugSerializationDescription)))
        }
    }
}
