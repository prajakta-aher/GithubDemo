import Foundation

public struct UserDetailUIModel: Identifiable, Equatable {
    public let id: String
    let imageUrl: URL?
    let name: String
    let followers: String
    let publicRepositories: String
}
