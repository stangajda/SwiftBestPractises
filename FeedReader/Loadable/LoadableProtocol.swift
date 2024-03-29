//
//  LoadableViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 19/07/2021.
//

import Foundation
import Combine

protocol LoadableProtocol {
    associatedtype REQUESTTYPE: Equatable
    associatedtype RESPONSETYPE: Equatable
    var input: PassthroughSubject<Action, Never> { get }
    func fetch() -> AnyPublisher<RESPONSETYPE, Error>
}

extension LoadableProtocol {
    typealias State = LoadableEnums<REQUESTTYPE, RESPONSETYPE>.State
    typealias Action = LoadableEnums<REQUESTTYPE, RESPONSETYPE>.Action

    func publishersSystem(_ state: State) -> AnyPublisher<State, Never> {
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.onStateChanged(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
    }

    func send(action: Action) {
        input.send(action)
    }

    private func onStateChanged() -> Feedback<State, Action> {
        Feedback { (state: State) -> AnyPublisher<Action, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.fetch()
                .map(
                    Action.onLoaded
                )
                .catch { error in
                    Just(Action.onFailedLoaded(error))
                }
                .eraseToAnyPublisher()
        }
    }

    private func userInput(input: AnyPublisher<Action, Never>) -> Feedback<State, Action> {
        Feedback { _ in
            input
        }
    }
}
