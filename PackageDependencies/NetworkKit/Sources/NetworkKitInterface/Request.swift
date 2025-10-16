import Foundation

open class Request<ResponseType> { // phantom type for binding a request to s response type
    let scheme: String
    let baseUrlString: String
    let path: String
    let method: HttpMethod
    let headers: [String: String]?
    let queryItemsDictionary: [String: String]
    let customDataBody: Data?

    public init(
        scheme: String,
        baseUrlString: String,
        path: String,
        method: HttpMethod,
        headers: [String : String]?,
        queryItems: [String: String] = [:],
        customDataBody: Data? = nil
    ) {
        self.scheme = scheme
        self.baseUrlString = baseUrlString
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItemsDictionary = queryItems
        self.customDataBody = customDataBody
    }

    public var urlRequest: URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseUrlString
        urlComponents.path = path
        var queryItems = [URLQueryItem]()
        for (key, value) in queryItemsDictionary {
            queryItems.append(.init(name: key, value: value))
        }
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = customDataBody
        return urlRequest
    }
}
