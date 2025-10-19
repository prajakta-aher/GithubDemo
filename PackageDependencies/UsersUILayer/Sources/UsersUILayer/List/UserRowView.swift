import SwiftUI
import UIUtilities

struct UserRowView: View {
    private let userModel: UserUIModel

    // MARK: Initializer

    init(userModel: UserUIModel) {
        self.userModel = userModel
    }

    // MARK: Properties

    var body: some View {
        HStack(spacing: SpacingConstants.padding) {
            AsyncImage(url: userModel.imageUrl) { image in
                    image.resizable()
                } placeholder: {
                    Image(
                        systemName: "person.crop.circle.fill"
                    )
                    .resizable()
                }
                .frame(width: SpacingConstants.iconWidth, height: SpacingConstants.iconHeight)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        Color.white,
                        lineWidth: 2
                    )
                )
                .shadow(radius: SpacingConstants.shadowCornerRadius)
            Text(userModel.name)
                .font(.title3)
            Spacer()
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .accessibilityElement(children: .combine)
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
