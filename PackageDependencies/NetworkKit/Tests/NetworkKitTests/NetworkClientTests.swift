import XCTest
@testable import NetworkKit
import NetworkKitMocks
import NetworkKitInterface

final class NetworkingClientTests: XCTestCase {
    private var jsonDecoder = JSONDecoder()
    private var mockSession: URLSessionProtocolMock!
    private var sut: NetworkClient!

    override func setUp() {
        super.setUp()
        mockSession = URLSessionProtocolMock()
        sut = NetworkClient(jsonDecoder: jsonDecoder, urlSession: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        sut = nil
        super.tearDown()
    }

    func testExecute_whenSessionReturnsData_thenReturnsDecodedResult() async throws {
        // Given
        let mockData = "\"MockResponse\""
        mockSession.mockData = mockData.data(using: .utf8) ?? Data()
        let mockRequest = Request<String>(
            scheme: "http",
            baseUrlString: "api.myapp.com",
            path: "/path",
            method: .get,
            headers: [:]
        )
        mockSession.httpUrlResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: try XCTUnwrap(mockRequest.urlRequest?.url),
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )
        )

        // When
        let actualResponse = try await sut.execute(request: mockRequest)

        // Then
        XCTAssertEqual("MockResponse", actualResponse, "Decoded response should match mock data")
    }

    func testExecute_whenErrorStatusCode_thenThrowsError() async throws {
        // Given
        let mockData = "\"MockResponse\""
        mockSession.mockData = mockData.data(using: .utf8) ?? Data()
        let mockRequest = Request<String>(
            scheme: "http",
            baseUrlString: "api.myapp.com",
            path: "/path",
            method: .get,
            headers: [:]
        )
        mockSession.httpUrlResponse = try XCTUnwrap(
            HTTPURLResponse(
                url: try XCTUnwrap(mockRequest.urlRequest?.url),
                statusCode: 500,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )
        )

        // When/Then
        do {
            _ = try await sut.execute(request: mockRequest)
            XCTFail("Expected error to be thrown for 500 status code")
        } catch {
            if case let ServiceError.errorResponseCode(code) = error {
                XCTAssertEqual(code, 500, "Should throw error with status code 500")
            } else {
                XCTFail("Expected ServiceError.errorResponseCode but got \(error)")
            }
        }
    }
}
