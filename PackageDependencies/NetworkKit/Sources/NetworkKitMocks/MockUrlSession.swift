import Foundation
import NetworkKitInterface

/// Mock Url session for testing the network layer end to end
/// intercepts the network calls when the URLSession methods are called
public final class MockUrlSession: URLProtocol {
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        switch MockDataProvider.getResult(for: request.url?.absoluteString ?? "") {
        case let .failure(error):
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)

        case let .success(data):
            guard let data = data,
                  let url = request.url,
                  let response = HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                  ) else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "MockUrlProtocol", code: 1))
                client?.urlProtocolDidFinishLoading(self)
                return
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    public override func stopLoading() {
    }
}
