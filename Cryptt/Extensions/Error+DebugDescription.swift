import Foundation

extension Error {
    var debugSerializationDescription: String {
        guard  let error = self as? DecodingError else {
            return "Serialization Error"
        }
        var debugDescription = ""
        switch error {
        case .typeMismatch(_, let context):
            debugDescription = context.debugDescription
        case .valueNotFound(_, let context):
            debugDescription = context.debugDescription
        case .keyNotFound(_, let context):
            debugDescription = context.debugDescription
        case .dataCorrupted(let context):
            debugDescription = context.debugDescription
        @unknown default:
            debugDescription = "Serialization Error"
        }
        return debugDescription
    }
}
