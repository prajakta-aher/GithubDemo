import Foundation

public struct UsersListApiModel: Codable, Equatable, Sendable {
    public private(set) var items: [UserItemApiModel]
    public private(set) var nextPage: String?

    public init(items: [UserItemApiModel], nextPage: String? = nil) {
        self.items = items
        self.nextPage = nextPage
    }

    public mutating func setNextPage(page: String?) {
        self.nextPage = page
    }

    public mutating func append(list: [UserItemApiModel]) {
        items.append(contentsOf: list)
    }
}
