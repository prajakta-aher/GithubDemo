import Foundation

public struct UserDetailApiModel: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let followers: Int
    public let publicRepositories: Int
    public let imageUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id = "node_id"
        case name = "login"
        case followers = "followers"
        case publicRepositories = "public_repos"
        case imageUrlString = "avatar_url"
    }
    
    public init(id: String, name: String, followers: Int, publicRepositories: Int, imageUrlString: String) {
        self.id = id
        self.name = name
        self.followers = followers
        self.publicRepositories = publicRepositories
        self.imageUrlString = imageUrlString
    }
}
