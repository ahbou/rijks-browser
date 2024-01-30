import Foundation
import SwiftUI
import Toolbox

/// ImageView wrapper that takes an URL and loads it asynchronously
public struct RemoteImageView: View {
    @ObservedObject
    var imageLoader: RemoteImageClient
    private var url: URL?

    public init(_ url: URL?) {
        self.url = url
        imageLoader = RemoteImageClient(url)
    }

    var content: some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: "photo")
            imageLoader.image.map { image -> Image in
                return Image(uiImage: image)
                    .resizable()
            }
            .transition(AnyTransition.opacity.animation(Animation.default))
        }
        .compositingGroup()
        .onAppear {
            imageLoader.start()
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }

    public var body: some View {
        content
    }
}
