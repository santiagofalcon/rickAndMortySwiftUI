//
//  APIClientTests.swift
//  rickAndMortySwiftUITests
//
//  Created by Santiago Falcon Gonzalez on 23/11/25.
//

import XCTest
@testable import rickAndMortySwiftUI

final class APIClientTests: XCTestCase {

    override func tearDown() {
        URLProtocolMock.testData = nil
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
    }

    func makeClient() -> APIClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)

        return APIClient(session: session)
    }

    func testAPISuccessDecodesData() async throws {
        let json = """
        {
          "info": { "count": 1, "pages": 1, "next": null, "prev": null },
          "results": []
        }
        """.data(using: .utf8)!

        URLProtocolMock.testData = json
        URLProtocolMock.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let client = makeClient()

        let result: CharactersResponse = try await client.fetch(
            CharactersResponse.self,
            from: URL(string: "https://test.com")!
        )

        XCTAssertEqual(result.info.count, 1)
    }

    func testServerErrorThrows() async {
        URLProtocolMock.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        URLProtocolMock.testData = Data()

        let client = makeClient()

        do {
            let _: CharactersResponse = try await client.fetch(
                CharactersResponse.self,
                from: URL(string: "https://test.com")!
            )
            XCTFail("Should throw")
        } catch {
            XCTAssert(error is NetworkError)
        }
    }
}


// MARK: - URLProtocolMock

final class URLProtocolMock: URLProtocol {

    static var testData: Data?
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = URLProtocolMock.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = URLProtocolMock.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = URLProtocolMock.testData {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
