import Foundation

public struct UserItemApiModel: Codable, Equatable {
    public let id: String
    public let name: String
    public let imageUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id = "node_id"
        case name = "login"
        case imageUrlString = "avatar_url"
    }

    public init(id: String, name: String, imageUrlString: String) {
        self.id = id
        self.name = name
        self.imageUrlString = imageUrlString
    }
}
