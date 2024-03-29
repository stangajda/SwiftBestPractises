//
//  MockmoviesDetailViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/07/2021.
//

import Foundation
import Combine

class MockMovieDetailViewModel: MovieDetailViewModelProtocol {
    var statePublisher: Published<State>.Publisher

    var movieList: MoviesListViewModel.MovieItem
    @Published var state: MovieDetailViewModel.State = .start()
    var input = PassthroughSubject<MovieDetailViewModel.Action, Never>()
    var mockState: MockState.State

    fileprivate var cancellable: AnyCancellable?

    init(_ movieList: MoviesListViewModel.MovieItem, _ mockState: MockState.State = .loaded) {
        self.mockState = mockState
        self.movieList = movieList
        self.statePublisher = _state.projectedValue
        onAppear()
    }

    func onAppear() {
        cancellable = self.assignNoRetain(self, to: \.state)
        if mockState != .start {
            send(action: .onAppear)
        }
    }

    func onDisappear() {
        send(action: .onReset)
        cancellable?.cancel()
    }

    func fetch() -> AnyPublisher<MovieDetailViewModel.MovieDetailItem, Error> {
        switch mockState {
        case .start, .loading:
            return Empty()
                .eraseToAnyPublisher()
        case .loaded:
            state = .loaded(MovieDetailViewModel.MovieDetailItem.mock)
            return Just(MovieDetailViewModel.MovieDetailItem.mock)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failedLoaded:
            return Fail(error: APIError.apiCode(404))
                .eraseToAnyPublisher()
        }
    }

}
