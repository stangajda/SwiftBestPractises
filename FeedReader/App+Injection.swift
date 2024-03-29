//
//  Swinject.swift
//  FeedReader
//
//  Created by Stan Gajda on 22/05/2023.
//

import Foundation
import Swinject

protocol InjectionRegistering {
    func initialRegistration()
}

// MARK: - Injection
public final class Injection: InjectionRegistering {
    static let main = Injection()
    private let container = Container()
    private lazy var assembler = Assembler()

    static var resolver: Container {
        Injection.main.container
    }

    func initialRegistration() {
        assembler = Assembler([
            NetworkAssembly(),
            ServiceAssembly(),
            ViewModelAssembly()
        ], container: container)
    }

    // mocks are in the same file because are used in FeedReader-Mock scheme as well
    func mockNetwork() {
        assembler = Assembler([
            MockNetworkAssembly(),
            ServiceAssembly()
        ], container: container)
    }

    func mockService() {
        assembler = Assembler([
            MockServiceAssembly(),
            ViewModelAssembly()
        ], container: container)
    }

    func mockViewModel() {
        assembler = Assembler([
            MockMoviesListViewModelAssembly(),
            MockMovieDetailViewModelAssembly(),
            MockImageViewModelAssembly()
        ], container: container)
    }

    func mockDetailViewModel() {
        mockViewModel()
        assembler.apply(assembly: MockImageViewModelItemDetailAssembly())
    }

    func mockFailedImageViewModel() {
        mockViewModel()
        assembler.apply(assembly: MockFailedImageViewModelAssembly())
    }

}
