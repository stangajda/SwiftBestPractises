//
//  LoadableEnums.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/07/2021.
//

import Foundation

struct LoadableEnums<Start, Loaded> where Start: Equatable, Loaded: Equatable {
    enum State: Equatable {
        case start(Start? = nil)
        case loading(Start? = nil)
        case loaded(Loaded)
        case failedLoaded(Error)

        static func == (lhs: LoadableEnums<Start, Loaded>.State, rhs: LoadableEnums<Start, Loaded>.State) -> Bool {
            switch (lhs, rhs) {
            case (.start(let lhsValue), .start(let rhsValue)):
                return lhsValue == rhsValue
            case (.loading(let lhsValue), .loading(let rhsValue)):
                return lhsValue == rhsValue
            case (.loaded(let lhsValue), .loaded(let rhsValue)):
                return lhsValue == rhsValue
            case (.failedLoaded(let lhsValue), .failedLoaded(let rhsValue)):
                return lhsValue.localizedDescription == rhsValue.localizedDescription
            default:
                return false
            }
        }
    }

    enum Action {
        case onAppear
        case onLoaded(Loaded)
        case onFailedLoaded(Error)
        case onReset
    }
}
