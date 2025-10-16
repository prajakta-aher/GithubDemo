import Foundation

public enum ServiceError: Error, Equatable {
    case responseDecodingError(errorDescription: String?)
    case urlMalformed
    case underlying(error: String?)
    case errorResponseCode(code: Int?)
}
