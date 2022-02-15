import Foundation
import Alamofire

public struct CRError: LocalizedError {

    public var message: String = ""
    public var code: Int = 0
    public var responseBody: [String: String]?

    public init(json: [String: String]) {
        message = json["detail"] ?? "Undefind error"
    }

    public init(dicitonary: NSDictionary) {
        message = ""
        dicitonary.enumerated().forEach {
            message += $0.element.key as? String ?? ""
            message += ": \(($0.element.value as? [String])?.joined() ?? "")"
        }
    }

    public init(message: String, code: Int = 0) {
        self.message = message
        self.code = code
    }
    
    public init(_ error: AFError) {
        message = error.localizedDescription
        code = error.responseCode ?? 0
    }
    
    public init(_ response: AFDataResponse<Data>) {
        if let data = response.data {
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                self.message = "Unrecognized error"
                return
            }
            if let dictionary = json as? [String: String] {
                responseBody = dictionary
                code = response.response?.statusCode ?? 0
            }
        } else if let error = response.error {
            message = error.localizedDescription
            code = error.responseCode ?? 0
        } else {
            message = "Unrecognized error"
        }
    }
    
    public var errorDescription: String? {
        return self.message
    }
}
