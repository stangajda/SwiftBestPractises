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

class MovieListViewModelSpec: QuickSpec {
    static var mockRequestUrl: URLRequest = URLRequest(url: MockAPIRequest[MockEmptyPath()]!).get()
    static var viewModel: AnyMoviesListViewModelProtocol?
 
    override class func spec() {
        describe("check movie list service"){
            var movieItem: Array<MoviesListViewModel.MovieItem>!
            var anotherMovieItem: Array<MoviesListViewModel.MovieItem>!

            beforeEach {
                Injection.main.mockService()
                @Injected var viewModel: AnyMoviesListViewModelProtocol
                Self.viewModel = viewModel
            }
            
            afterEach {
                viewModel?.onDisappear()
                viewModel = nil
            }

            context("when send on appear action") {
                beforeEach {
                    let moviesFromData: Movies = Data.jsonDataToObject(Config.Mock.MovieList.movieListResponseResult)
                    let anotherMoviesFromData: Movies = Data.jsonDataToObject(Config.Mock.MovieList.anotherMovieListResponseResult)

                    let result: Result<Movies, Error> = .success(moviesFromData)
                    @Injected(result) var service: MovieListServiceProtocol
                    
                    
                    movieItem = moviesFromData.results.map { movie in
                        MoviesListViewModel.MovieItem(movie)
                    }
                    
                    anotherMovieItem = anotherMoviesFromData.results.map { movie in
                        MoviesListViewModel.MovieItem(movie)
                    }
                    
                    viewModel?.onAppear()
                }
                
                it("it should match from loaded state counted objects in array"){
                    expect(self.viewModel?.state).toEventually(beLoadedStateMoviesCount(22))
                }
                
                it("it should get movies from loaded state match mapped object"){
                    expect(self.viewModel?.state).toEventually(equal(.loaded(movieItem)))
                }
                
                it("it should get movies from loaded state match not mapped object"){
                    expect(self.viewModel?.state).toEventuallyNot(equal(.loaded(anotherMovieItem)))
                }
            }
            
            context("when send on reset action") {
                beforeEach { [self] in
                    viewModel?.onAppear()
                    viewModel?.onDisappear()
                }
                
                it("it should get start state"){
                    expect(self.viewModel?.state).toEventually(equal(.start()))
                }
            }
            
            let errorCodes: Array<Int> = [300,404,500]
            errorCodes.forEach { errorCode in
                context("when error response with error code \(errorCode)") {
                    beforeEach {
                        let result: Result<Movies, Error> = .failure(APIError.apiCode(errorCode))
                        @Injected(result) var service: MovieListServiceProtocol
                        viewModel?.onAppear()
                    }
                    
                    it("it should get state failed loaded with error code \(errorCode)"){ [self] in
                        expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.apiCode(errorCode))))
                    }
                }
            }
            
            context("when error response unknown error") {
                beforeEach {
                    let result: Result<Movies, Error> = .failure(APIError.unknownResponse)
                    @Injected(result) var service: MovieListServiceProtocol
                    viewModel?.onAppear()
                }
                
                it("it should get state failed loaded with unknown error"){
                    expect(self.viewModel?.state).toEventually(equal(.failedLoaded(APIError.unknownResponse)))
                }
            }
        }
    }
}
