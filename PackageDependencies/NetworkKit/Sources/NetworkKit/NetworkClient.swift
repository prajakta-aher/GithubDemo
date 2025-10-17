import Foundation
import NetworkKitInterface

extension URLSession: URLSessionProtocol {}

final class NetworkClient: NetworkClientProtocol {
    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSessionProtocol

    init(
        jsonDecoder: JSONDecoder,
        urlSession: URLSessionProtocol
    ) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }

    func execute<ResponseType: Decodable>(
        request: Request<ResponseType>,
        responseheaderName: String?
    ) async throws -> (response: ResponseType, responseHeader: String?) {
        do {
            guard let urlRequest = request.urlRequest else {
                throw ServiceError.urlMalformed
            }
            let (data, urlResponse) = try await urlSession.data(for: urlRequest, delegate: nil)
            let httpResponse = (urlResponse as? HTTPURLResponse)
            let statusCode = httpResponse?.statusCode
            // If status code not 200 then throw an error
            guard let statusCode = statusCode,
                  (200..<300).contains(statusCode) else {
                throw ServiceError.errorResponseCode(code: statusCode)
            }
            return (
                response: try jsonDecoder.decode(ResponseType.self, from: data),
                responseHeader: httpResponse?.value(forHTTPHeaderField: responseheaderName ?? "")
            )
        } catch let error as ServiceError {
            throw error
        } catch let error as DecodingError {
            throw ServiceError.responseDecodingError(errorDescription: error.errorDescription)
        } catch {
            throw ServiceError.underlying(error: error.localizedDescription)
        }
    }
}
