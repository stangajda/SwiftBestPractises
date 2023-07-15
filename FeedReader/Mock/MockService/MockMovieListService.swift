//
//  MockMovieListService.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 12/07/2023.
//

import Foundation
import Combine

struct MockMovieListService: MovieListServiceProtocol {
    fileprivate static var result: Result<Movies, Error> = .success(Movies(results: [], page: 0))

    static func mockResult(_ result: Result<Movies, Error>) {
        Self.result = result
    }
    
    func fetchMovies(_ request: URLRequest) -> AnyPublisher<Movies, Error> {
        return Self.result.publisher.eraseToAnyPublisher()
    }
}