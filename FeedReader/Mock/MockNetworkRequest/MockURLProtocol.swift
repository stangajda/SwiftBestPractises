//
//  MockURLProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 18/06/2021.
//

import Foundation

struct MockAPIRequest: APIUrlBuilderProtocol {
    static var baseURL: URL { URL(string: "https://any.test.com/") ?? URL(fileURLWithPath: String()) }
    static var imageURL: URL { URL(string: "https://image.test.com/") ?? URL(fileURLWithPath: String()) }
    static var prefix: String { "stubPrefix" }
    static var type: String { "stubTypeI" }
    static var timeWindow: String { "stubTimeWindow" }
    static var apiKey: String { "stubKey" }
}

extension MockURLProtocol {
    struct MockedResponse {
        let request: URLRequest
        let result: Result<Data, Swift.Error>
        let apiCode: APICode
        let httpVersion: String
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
    }
}

extension MockURLProtocol.MockedResponse {
    enum Error: Swift.Error {
        case failedMockCreation
    }

    init<T>(
            request: URLRequest,
            result: Result<T, Swift.Error>,
            apiCode: APICode = 200,
            httpVersion: String = "HTTP/1.1",
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1
    ) throws where T: Encodable {
        self.request = request
        switch result {
        case let .success(value):
            self.result = .success(try JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.apiCode = apiCode
        self.httpVersion = httpVersion
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }

    init(
        request: URLRequest,
        result: Result<Data, Swift.Error>,
        apiCode: APICode = 200,
        httpVersion: String = "HTTP/1.1",
        headers: [String: String] = ["Content-Type": "application/json"],
        loadingTime: TimeInterval = 0.1
    ) throws {
        self.request = request
        switch result {
        case let .success(value):
            self.result = .success(value)
        case let .failure(error):
            self.result = .failure(error)
        }
        self.apiCode = apiCode
        self.httpVersion = httpVersion
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }

}

extension MockURLProtocol {
    static var mock: MockedResponse?
}

class MockURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let mock = MockURLProtocol.mock,
            let url = request.url,
            let response = mock.customResponse ??
                HTTPURLResponse(url: url,
                statusCode: mock.apiCode,
                httpVersion: mock.httpVersion,
                headerFields: mock.headers) {
            DispatchQueue.main.asyncAfter(deadline: .now() + mock.loadingTime) { [weak self] in
                guard let self = self else { return }
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                switch mock.result {
                case let .success(data):
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)
                case let .failure(error):
                    let failure = NSError(domain: NSURLErrorDomain, code: 1,
                                          userInfo: [NSUnderlyingErrorKey: error])
                    self.client?.urlProtocol(self, didFailWithError: failure)
                }
            }
        }
    }

    override func stopLoading() {

    }

}
