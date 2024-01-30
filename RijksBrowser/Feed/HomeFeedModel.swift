//
//  HomeFeedModel.swift
//  Rijksmuseum

import Combine
import Foundation
import RijksAPI
import Toolbox

/// ViewModel for `HomeFeedView`
class HomeFeedModel: ObservableObject {
    /// Holds API responses
    @Published var objects: [ArtObject] = []
    /// Loading state
    @Published var isLoading = false
    /// Current page
    private var currentPage = 1
    /// Prevent useless API calls
    private var hasMorePages = true
    /// Search query
    @Published var query: String = "" {
        didSet {
            guard query != oldValue else { return }

            resetState()
            loadFeed()
        }
    }

    /// Feed subscriber
    var subscriber: AnyCancellable?
    /// Search query publisher
    var publisher: AnyCancellable?
    /// Inner `RijksAPI` client
    private let client = RijksAPI()

    init() {
        resetState()
        loadFeed()

        publisher = $query
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink(receiveValue: { _ in })
    }

    func loadMoreIfNeeded(from object: ArtObject) {
        // Start loading when we're at 5 items from the end
        let threshold = objects.index(objects.endIndex, offsetBy: -5)

        guard
            let objectIndex = objects.firstIndex(where: { $0.id == object.id }),
            objectIndex == threshold
        else {
            return
        }

        loadFeed()
    }

    func loadFeed() {
        guard !isLoading, hasMorePages else {
            return
        }

        isLoading = true

        subscriber = client.getFeed(page: currentPage, query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in

                switch completion {
                case let .failure(error):
                    // TODO: Display error
                    Log.error(error)
                case .finished:
                    break
                }
            }) { [weak self] objects in
                self?.hasMorePages = !objects.isEmpty
                self?.isLoading = false

                guard self?.hasMorePages ?? false else { return }

                self?.currentPage += 1
                self?.objects.append(contentsOf: objects)
            }
    }

    /// Clean state
    private func resetState() {
        currentPage = 1
        isLoading = false
        hasMorePages = true
        objects.removeAll()
    }
}
