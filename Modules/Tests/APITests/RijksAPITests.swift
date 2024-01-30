import Combine
@testable import RijksAPI
import XCTest

class RijksAPITests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // Validate feed response
    func testFeed() {
        // TODO: Use a mocked URLSession
        let client = RijksAPI(session: .shared)

        // Result holders
        var objects = [ArtObject]()
        var error: Error?
        let expectation = self.expectation(description: "feedItems")

        client
            .getFeed(query: nil)
            .sink(receiveCompletion: { completion in
                      switch completion {
                          case .finished:
                              break
                          case .failure(let encounteredError):
                              error = encounteredError
                      }
                      expectation.fulfill()
                  },
                  receiveValue: { value in
                    objects = value

                  }).store(in: &cancellables)

        waitForExpectations(timeout: 3)

        XCTAssertNil(error)
        XCTAssertFalse(objects.isEmpty)

        // XCTAssertEqual(objects.count, 20)
        // We could assert the size but it's easily broken
    }

    /// TODO: 
    func testQuery() {

    }
}
