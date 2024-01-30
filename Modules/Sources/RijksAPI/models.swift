import Foundation

/// Response Wrapper
struct Response: Codable {
    let elapsedMilliseconds: Double
    let count: Int
    let artObjects: [ArtObject]
}

/// Response Body
public struct ArtObject: Codable, Identifiable {
    public let id: String
    public let title: String
    public var longTitle: String
    public var headerImage: Image
    public var webImage: Image
}

/// Shared model for images/media
public struct Image: Codable {
    public let guid: String?
    public let url: URL?
}
