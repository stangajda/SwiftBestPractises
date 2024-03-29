//
//  MockImageService.swift
//  FeedReader
//
//  Created by Stan Gajda on 13/07/2023.
//

import Combine
import UIKit

struct MockImageService: ImageServiceProtocol {
    private static var result: Result<UIImage, Error>?

    init() {
    }

    init(_ result: Result<UIImage, Error>) {
        Self.result = result
    }

    func fetchImage(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        guard let result = Self.result else {
            return Empty().eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
