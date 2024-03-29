//
//  MoviesListView.swift
//  FeedReader
//
//  Created by Stan Gajda on 11/07/2021.
//

import SwiftUI
import PreviewSnapshots

// MARK: - Main
struct MoviesListView<ViewModel>: View where ViewModel: AnyMoviesListViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
            NavigationStack {
                switch viewModel.state {
                case .start:
                    startView
                case .loading:
                    loadingView
                case .loaded(let movies):
                    loadedView(movies).navigationTitle(Config.MovieList.title).navigationBarTitleDisplayMode(.inline)
                case .failedLoaded(let error):
                    failedView(error)
                }
            }
            .onChange(of: scenePhase) { newPhase in if newPhase == .active {
                        viewModel.onActive()
                } else if newPhase == .background {
                    viewModel.onBackground()
                }
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}

// MARK: - States
extension MoviesListView {
    typealias MovieDetailViewWrapper = MovieDetailView<AnyMovieDetailViewModelProtocol>

    @ViewBuilder
    private var startView: some View {
        Color.clear
            .onAppear {      viewModel.onAppear()
            }
    }

    @ViewBuilder
    var loadingView: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }

    @ViewBuilder
    func loadedView(_ movies: [MoviesListViewModel.MovieItem]) -> some View {
        listMovies(movies)
            .navigationDestination(for: MoviesListViewModel.MovieItem.self) { movie in
                makeMovieDetailView(for: movie)
            }
    }

    @ViewBuilder
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error)
    }

    func listMovies(_ movies: [MoviesListViewModel.MovieItem]) -> some View {
        List(movies) { movie in
            NavigationLink(value: movie) {
                MovieRowView(movie: movie)
            }
        }
    }

    func makeMovieDetailView(for movie: MoviesListViewModel.MovieItem) -> some View {
        @Injected(movie) var viewModel: AnyMovieDetailViewModelProtocol
        return MovieDetailViewWrapper(viewModel)
    }
}

// MARK: - Preview
#if DEBUG
struct MoviesListView_Previews: PreviewProvider {

    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }

    static var snapshots: PreviewSnapshots<AnyMoviesListViewModelProtocol> {
            Injection.main.mockViewModel()
            @Injected(name: .movieListStateLoaded) var viewModelLoaded: AnyMoviesListViewModelProtocol
            @Injected(name: .movieListStateStart) var viewModelStart: AnyMoviesListViewModelProtocol
            @Injected(name: .movieListStateLoading) var viewModelLoading: AnyMoviesListViewModelProtocol
            @Injected(name: .movieListStateFailed) var viewModelFailed: AnyMoviesListViewModelProtocol
            return PreviewSnapshots(
                configurations: [
                    .init(named: .movieListStateLoaded, state: viewModelLoaded),
                    .init(named: .movieListStateStart, state: viewModelStart),
                    .init(named: .movieListStateLoading, state: viewModelLoading),
                    .init(named: .movieListStateFailed, state: viewModelFailed)
                ],
                configure: { state in
                    MoviesListView(viewModel: state)
                }
            )
        }
}
#endif
