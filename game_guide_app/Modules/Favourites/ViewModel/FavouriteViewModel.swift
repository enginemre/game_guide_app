//
//  FavouriteViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 23.01.2023.
//

import Foundation

class FavouriteViewModel {
    
    private let model = FavouriteModel()
    
    // Data Binding
    
    var onErrorOccurred : ((String) -> ())?
    
    var onDataRecived : (([GameDetail]?)-> ())?
    
    func didViewLoad(){
        fetchFavourites()
    }
    
    init(){
        model.delegate = self
    }
    
    func fetchFavourites(){
        model.fetchFavouriteGames()
    }
    
}


extension FavouriteViewModel : FavouriteModelDelegate{
    func didDataFetch() {
        onDataRecived?(model.favourites)
    }
    
    func didDataNotFetch() {
        onErrorOccurred?("Please try again later".localized())
    }
    
    
}
