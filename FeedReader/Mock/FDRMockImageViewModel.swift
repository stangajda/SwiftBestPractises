//
//  MockImageViewModel.swift
//  FeedReader
//
//  Created by Stan Gajda on 23/07/2021.
//

import Foundation
import UIKit

class FDRMockImageViewModel: FDRImageViewModel{
    var image: UIImage?
    enum MockState {
        case itemList
        case itemDetail
    }
    override var state: State{
        guard let image = image else {
            return .start()
        }
        return .loaded(ImageItem(image))
    }
    
    init(_ state: MockState){
        super.init(imageURL: "mockUrl")
        switchState(state)
    }
    
    func switchState(_ state: MockState){
        switch state {
        case .itemList:
            image = UIImage(named: "StubImageMovieMedium")
        case .itemDetail:
            image = UIImage(named: "StubImageMovieDetailsBig")
        }
    }
}