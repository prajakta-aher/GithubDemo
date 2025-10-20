import SwiftUI

struct UserDetailView<ViewProtocol: UserDetailViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewProtocol

    init(viewModel: ViewProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .frame(
                        width: SpacingConstants.largeWidth,
                        height: SpacingConstants.largeHeight,
                        alignment: .center
                    )

            case .error(let message):
                Color.clear
                    .alert(
                        message,
                        isPresented: .constant(true),
                        actions: {}
                    )

            case .loaded(let detail):
                VStack(spacing: SpacingConstants.padding2X) {
                    imageView(imageUrl: detail.imageUrl)
                    Text(detail.name)
                        .multilineTextAlignment(.center)
                        .font(.title)
                    VStack(alignment: .leading, spacing: SpacingConstants.padding) {
                        // Image names should be a part of design system
                        textWithicon(imageName: "person.2.fill", text: detail.followers)
                        textWithicon(imageName: "shippingbox.fill", text: detail.publicRepositories)
                    }
                    .padding(.all, SpacingConstants.padding)
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(SpacingConstants.largeCornerRadius)
                }
                .padding(.top, SpacingConstants.padding2X)
            }
        }
        .onAppear {
            viewModel.loadDetails()
        }
    }
    
    @ViewBuilder
    private func textWithicon(imageName: String, text: String) -> some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.title2)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, SpacingConstants.padding2X)
    }
    
    @ViewBuilder
    private func imageView(imageUrl: URL?) -> some View {
        AsyncImage(url: imageUrl) { image in
                image
                .resizable()
                .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(
                    // Image names should be a part of design system
                    systemName: "person.crop.circle.fill"
                )
                .resizable()
                .scaledToFit()
            }
            .frame(width: SpacingConstants.largeWidth, height: SpacingConstants.largeHeight)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(
                    Color.white,
                    lineWidth: SpacingConstants.strokeWidth
                )
            )
            .shadow(radius: SpacingConstants.shadowCornerRadius)
            .padding(SpacingConstants.shadowCornerRadius)
    }
}
