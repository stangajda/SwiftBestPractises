//
//  MockMoviesListViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation

class MockMoviesListViewModel: MoviesListViewModel{
    var internalState: State = .start
    enum MockState {
        case loading
        case loaded
        case error
    }
    
    override var state: State{
        return internalState
    }
    
    init(_ state:MockState){
        super.init()
        switchState(state)
    }
    
    var mockItemsArray: Array<MovieItem>{
        Array(repeating: MovieItem(Movie.mock), count: 20)
    }
    
    func switchState(_ state:MockState){
        switch state {
        case .loading:
            internalState = .loading
        case .loaded:
            internalState = .loaded(mockItemsArray)
        default:
            break
        }
    }
}