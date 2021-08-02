//
//  MockMovie.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

extension FDRMovie{
    static let mock = FDRMovie(id: 497698, title: "mock title", vote_average: 8.2, poster_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg")
}

extension FDRMovieDetail{
    static let mock = FDRMovieDetail(id: 4971212, title: "mock title detail", overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", backdrop_path: "/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg")
}

extension FDRMoviesListViewModel.MovieItem{
    static let mock = FDRMoviesListViewModel.MovieItem(FDRMovie.mock)
}

extension FDRMovieDetailViewModel.MovieDetailItem{
    static let mock = FDRMoviesListViewModel.MovieItem(FDRMovie.mock)
}
