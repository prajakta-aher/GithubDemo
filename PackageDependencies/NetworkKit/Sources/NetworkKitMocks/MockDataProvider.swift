import Foundation

enum MockDataProvider {
    // Immutable configuration loaded once - inherently thread-safe
    static let responses: [String: String] = {
        if let url = Bundle.module.url(forResource: "MockResponses", withExtension: "json"),
           let data = try? Data.init(contentsOf: url) {
            return (try? JSONDecoder().decode([String: String].self, from: data)) ?? [:]
        }
        return [:]
    }()

    // Get response for a specific URL (thread-safe - reading immutable data)
    static func getResult(for urlString: String) -> Result<Data?, NSError> {
        let testData: Result<Data?, NSError> = if let response = responses[urlString] {
            .success(response.data(using: .utf8))
        } else {
            .failure(.init(domain: "Error", code: -1))
        }
        return testData
    }
}

