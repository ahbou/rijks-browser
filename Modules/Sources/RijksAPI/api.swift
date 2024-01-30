import Combine
import Foundation
import Toolbox

enum RikjsRoute {
    case feed([URLQueryItem])

    private var path: String {
        switch self {
        case .feed:
            return "collection"
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .feed:
            return .get
        }
    }

    func asURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.rijksmuseum.nl"
        components.path = "/api/en/" + path

        switch self {
        case .feed(let items):
            components.queryItems = items.isEmpty ? nil : items
        }

        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            return nil // TODO: Should probably throw
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

public class RijksAPI {
    /// The underlying URLSession
    private let urlSession: URLSession
    /// Preconfigure JSONDecoder
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    /// Rikjs Museum API key
    private let apiKey = Secrets.rijksApiKey

    public init(session: URLSession = .shared) {
        self.urlSession = session
    }

    public func getFeed(
        page: Int = 1,
        query: String?
    ) -> AnyPublisher<[ArtObject], Error> {
        let queryItems = buildURLQueryItems(for: page, query: query)

        guard let urlRequest = RikjsRoute.feed(queryItems).asURLRequest() else {
            return Fail(
                error: "Bad base url"
            ).eraseToAnyPublisher()
        }
        #if DEBUG
        Log.info(urlRequest)
        #endif
        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Response.self, decoder: jsonDecoder)
            .map(\.artObjects)
            .eraseToAnyPublisher()
    }

    private func buildURLQueryItems(
        for page: Int,
        query: String?
    ) -> [URLQueryItem] {
        return [
            // API Key
            URLQueryItem(name: "key", value: apiKey),
            // Search term if any
            URLQueryItem(name: "q", value: query),
            // Limit to results with images
            URLQueryItem(name: "imgonly", value: "True"),
            // France 🇫🇷
            URLQueryItem(name: "place", value: "France"),
            // Current page
            URLQueryItem(name: "p", value: page.description),
            // Page size
            URLQueryItem(name: "ps", value: 20.description)
        ]
    }
}
