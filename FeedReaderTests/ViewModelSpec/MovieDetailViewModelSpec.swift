//
//  MovieListViewModelSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 08/06/2023.
//

import Foundation
import UIKit
@testable import FeedReader
import Combine
import Nimble
import Quick

class MovieDetailViewModelSpec: QuickSpec, MockableMovieDetailViewModelProtocol {
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    static var viewModel: (any MovieDetailViewModelProtocol)? = nil
    
    typealias Mock = MockURLProtocol.MockedResponse
    
    override class func spec() {
        describe("check movie list service"){
            
            var movieItem: MovieDetailViewModel.MovieDetailItem!
            var anotherMovieItem: MovieDetailViewModel.MovieDetailItem!

            beforeEach {
                viewModel = MovieDetailViewModel.instance(MoviesListViewModel.MovieItem.mock)
            }
            
            afterEach {
                viewModel?.onDisappear()
                MockURLProtocol.mock = nil
                viewModel = nil
                MovieDetailViewModel.deallocateCurrentInstances()
            }

            context("when send on appear action") {
                beforeEach {
                    let moviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.movieDetailResponseResult)
                    let anotherMoviesFromData: MovieDetail = Data.jsonDataToObject(Config.Mock.MovieDetail.anotherMovieDetailResponseResult)
                    mockResponse(result: .success(moviesFromData) as Result<MovieDetail, Swift.Error>)
                    movieItem = MovieDetailViewModel.MovieDetailItem(moviesFromData)
                    anotherMovieItem = MovieDetailViewModel.MovieDetailItem(anotherMoviesFromData)
                    viewModel?.onAppear()
                }
                
                it("it should get movies from loaded state match mapped object"){
                    expect(self.viewModel?.state).toEventually(equal(.loaded(movieItem)))
                }
                
                it("it should get movies from loaded state match not mapped object"){
                    expect(self.viewModel?.state).toEventuallyNot(equal(.loaded(anotherMovieItem)))
                }
            }
            
            context("when send on reset action") {
                beforeEach {
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }
                
                it("it should get start state"){
                    expect(self.viewModel?.state).toEventually(equal(.start(497698)))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach {
                        mockResponse(result: .failure(APIError.apiCode(errorCode)))
                        viewModel?.onAppear()
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){
                        expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach {
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                }
                
                it("it should get state failed loaded with unknown error"){
                    expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
            
            context("when 1 instance exist") {
                beforeEach {
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                }
                
                it("it should get MovieDetailViewModel instances count 1"){
                    expect(MovieDetailViewModel.instances.count).to(equal(1))
                }
            }
            
            context("when deaalocate MovieDetailViewModel instances") {
                beforeEach {
                    mockResponse(result: .failure(APIError.unknownResponse))
                    viewModel?.onAppear()
                    MovieDetailViewModel.deallocateCurrentInstances()
                }
                
                it("it should get MovieDetailViewModel instances count 0"){
                    expect(MovieDetailViewModel.instances.count).to(equal(0))
                }
            }
        }
    }
}
