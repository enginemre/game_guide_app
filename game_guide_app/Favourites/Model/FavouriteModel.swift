//
//  FavouriteModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 23.01.2023.
//

import Foundation

protocol FavouriteModelDelegate : AnyObject{
    
    func didDataFetch()
    
    func didDataNotFetch()
}


class FavouriteModel{
    
    weak var delegate : FavouriteModelDelegate?
    
    private(set) var favourites : [GameDetail] = []
    
    private let coreDataManager  = CoreDataManager(game: "game_guide_app")
    
    func fetchFavouriteGames(){
        coreDataManager.getAllFavourites { res in
            switch(res){
            case.success(let data) :
                guard let game = data else {
                    self.delegate?.didDataNotFetch()
                    return
                }
                self.favourites =  game.map { game in
                    game.toGameDetail()
                }
                self.delegate?.didDataFetch()
            case.failure(_):
                self.delegate?.didDataNotFetch()
                return
            }
        }
    }
    
    
    
    
}
