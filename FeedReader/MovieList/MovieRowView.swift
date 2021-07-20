//
//  MovieRowView.swift
//  FeedReader
//
//  Created by Stan Gajda on 12/07/2021.
//

import SwiftUI

struct MovieRowView: View {
    @State var movie: MoviesListViewModel.MovieItem
    
    var body: some View {
        HStack{
            ImageView(viewModel: ImageViewModel(imageURL: movie.poster_path))
                .rowImageSize
            Text(movie.title)
                .font(.title)
        }
        .padding()
        .rowSize
    }
}

#if DEBUG
struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MovieRowView(movie: MoviesListViewModel.MovieItem.mock)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
