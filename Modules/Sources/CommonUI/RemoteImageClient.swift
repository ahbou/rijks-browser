import Combine
import Foundation
import UIKit

/// Dedicated URLSession client to download and cache images
public class RemoteImageClient: ObservableObject {
    /// Task state
    private(set) var isLoading = false
    /// Image URL
    private var url: URL?
    /// Internal URLSession
    private let session: URLSession
    /// Final UIImage
    @Published var image: UIImage?
    /// Task subscription token
    private var subscriber: AnyCancellable?

    init(
        _ url: URL?,
        session: URLSession = URLSession(configuration: RemoteImageClient.sessionConfiguration)
    ) {
        self.url = url
        self.session = session
    }

    func start() {
        guard !isLoading, let imgURL = url else {
            return
        }

        isLoading = true

        subscriber = session.dataTaskPublisher(for: imgURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
                self?.isLoading = false
            }
    }

    func cancel() {
        subscriber?.cancel()
        subscriber = nil
        isLoading = false
    }

    private static var sessionConfiguration: URLSessionConfiguration {
        let cachesURL = FileManager.default.cachesDir
        // 100Mo in memory & 1Go on disk
        let cache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 1_000_000_000, directory: cachesURL)
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.requestCachePolicy = .returnCacheDataElseLoad
        return config
    }
}
