import SwiftUI

struct UserRowView: View {
    // MARK: Nested views
    enum AccessibilityIdentifiers: String {
        case image = "user_list_row_image"
        case usernameText = "user_list_row_username"
    }

    private let userModel: UserUIModel

    // MARK: Initializer

    init(userModel: UserUIModel) {
        self.userModel = userModel
    }

    // MARK: Properties

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(
                url: userModel.imageUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image(
                        systemName: "person.crop.circle.fill"
                    )
                        .resizable()
                }
                .frame(width: 50, height: 50)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        Color.white,
                        lineWidth: 2
                    )
                )
                .shadow(radius: 5)
                .accessibilityIdentifier(AccessibilityIdentifiers.image.rawValue)
            Text(userModel.name)
                .font(.title3)
                .accessibilityIdentifier(AccessibilityIdentifiers.usernameText.rawValue)
            Spacer()
        }
    }
}

#Preview {
    UserRowView(
        userModel: UserUIModel(
            id: "id",
            imageUrl: nil,
            name: "username"
        )
    )
}
