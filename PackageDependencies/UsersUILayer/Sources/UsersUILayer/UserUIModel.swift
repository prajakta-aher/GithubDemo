import Foundation

public struct UserUIModel: Identifiable, Equatable {
    public let id: String
    let imageUrl: URL?
    let name: String
}
