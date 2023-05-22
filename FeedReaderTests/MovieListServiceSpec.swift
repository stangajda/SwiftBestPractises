//
//  MovieListServiceSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 02/08/2021.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
//import Resolver
import Nimble
import Quick

class MovieListServiceSpec: QuickSpec, MockableMovieListServiceProtocol {
    lazy var mockManager: MovieListServiceProtocol = MovieListService()
    lazy var cancellable: AnyCancellable? = nil
    lazy var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[TrendingPath()]!).get()
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    required init() {
        super.init()
        self.setUpSpec()
    }
    
    override func spec() {
        describe("check movie list service"){

            var moviesFromData: Movies!
            var anotherMoviesFromData: Movies!
            
            afterEach { [unowned self] in
                MockURLProtocol.mock = nil
                cancellable?.cancel()
                cancellable = nil
            }

            context("when successful json data") {
                beforeEach { [self] in
                    moviesFromData = Data.jsonDataToObject("MockMovieListResponseResult.json")
                    anotherMoviesFromData = Data.jsonDataToObject("MockAnotherMovieListResponseResult.json")
                    mockResponse(result: .success(moviesFromData) as Result<Movies, Swift.Error>)
                }
                
                it("it should get successful response match mapped object"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.checkResponse(done: done){ result in
                                result.isExpectSuccessToEqual(moviesFromData)
                        }
                    }
                }

                it("it should get successful response not match mapped object"){ [unowned self] in
                    await waitUntil{ [unowned self] done in
                        cancellable = self.checkResponse(done: done){ result in
                                result.isExpectSuccessNotToEqual(anotherMoviesFromData)
                        }
                    }
                }
                
            }
            
        }
    }
}
