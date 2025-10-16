import XCTest
import NetworkKitInterface
import NetworkKitMocks
@testable import NetworkKit

final class NetworkClientIntegrationTests: XCTestCase {
    private lazy var testSession: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlSession.self] // mock so actual endpoint is not called
        return URLSession(configuration: config)
    }()

    private var sut: NetworkClient!

    override func setUp() {
        super.setUp()
        sut = NetworkClient(jsonDecoder: JSONDecoder(), urlSession: testSession)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExecute_whenValidData_thenReturnsDecodedResponse() async throws {
        // Given
        let expectedResponse = "Mock response"
        let request = Request<String>(
            scheme: "https",
            baseUrlString: "someapi.com",
            path: "/path",
            method: .get,
            headers: [:]
        )

        // When
        let response = try await sut.execute(request: request)

        // Then
        XCTAssertEqual(response, expectedResponse, "Response should match the mock response")
    }

    func testExecute_whenError_thenThrowsServiceError() async throws {
        // Given
        let request = Request<String>(
            scheme: "https",
            baseUrlString: "someapi.com",
            path: "/error",
            method: .get,
            headers: [:]
        )

        // When/Then
        do {
            _ = try await sut.execute(request: request)
            XCTFail("Expected ServiceError to be thrown")
        } catch {
            // Verify it's a ServiceError.underlying since MockDataProvider returns NSError
            if case .underlying = error as? ServiceError {
                XCTAssertTrue(true, "Correctly threw ServiceError.underlying")
            } else {
                XCTFail("Expected ServiceError.underlying but got \(error)")
            }
        }
    }
}
