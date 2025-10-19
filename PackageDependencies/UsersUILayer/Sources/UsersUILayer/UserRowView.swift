import SwiftUI

struct UserRowView: View {
    private let userModel: UserUIModel

    init(userModel: UserUIModel) {
        self.userModel = userModel
    }

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
            Text(userModel.name)
                .font(.title3)
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
