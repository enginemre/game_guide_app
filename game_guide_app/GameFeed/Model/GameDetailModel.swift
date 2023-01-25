//
//  GameDetailModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 22.01.2023.
//

import Foundation


protocol GameDetailProtocol : AnyObject{
    func didDataFetch()
    
    func didDataNotFetch()
    
    func didDataFavourite(_ status : Bool)
}


class GameDetailModel {

    private(set) var data : GameDetail?
    
    
    weak var delegate : GameDetailProtocol?
    
    private let gameFeedManager = GameFeedManager()
    private let coreDataManager = CoreDataManager(game:"game_guide_app")
    
    func fetchGameFromAPI(by id : Int){
        
        var parameters = NetworkHelper.shared.parameters
        gameFeedManager.getGame(by: id, parameters: parameters) { data, message in
            guard let game = data else {
                self.delegate?.didDataNotFetch()
                return
            }
            self.data = game
            self.delegate?.didDataFetch()
        }
        
    }
    
    func containData(id : Int) -> Bool{
        return coreDataManager.containData(id: id)
    }
    
    
    func fetchGameFromDB(id:Int){
        coreDataManager.getGameBy(id: id) { res in
            switch(res){
            case .failure(_):
                self.delegate?.didDataNotFetch()
                return
            case .success(let data):
                guard let game = data else {
                    self.delegate?.didDataNotFetch()
                    return
                }
                self.data = GameDetail(id: Int(game.id), name: game.name, description: game.descriptions, released: game.released, updated: game.updatedDate, backgroundImage: game.imageUrl, backgroundImageAdditional: game.imageUrl, website: game.website, rating: game.rating, ratingTop: Int(game.ratingTop),isFavourite: game.isFavourite,note : game.note ?? "")
                self.delegate?.didDataFetch()
            }
            
        }
    }
    
    func setFavourite(){
        let favourite = data?.isFavourite ?? false
        // if doesn't contain data add else update
        if(coreDataManager.containData(id: data!.id!)){
            coreDataManager.updateGame(id: data!.id!, note: data?.note ?? "", favourite: favourite) { res in
                
                switch(res){
                    case .success(_):
                        self.delegate?.didDataFavourite(!favourite)
                    case .failure(_):
                        print("Error ocurred while favouriting item")
                        self.delegate?.didDataFavourite(favourite)
                }
            }
        }else{
            if let game = data {
                coreDataManager.saveGame(game, "", completion: { res in
                    switch(res){
                    case .success(_):
                        self.data?.isFavourite = !favourite
                        self.delegate?.didDataFavourite(!favourite)
                    case .failure(_):
                        self.delegate?.didDataFavourite(favourite)
                        return
                    }
                    
                },isFavourite: !favourite)
            }
        }
        
       
        
    }
    
    private func saveGameToDB(){
        if let game = data {
            coreDataManager.saveGame(game, "", completion: { res in
                switch(res){
                case .success(_):
                    print("Item added successfully")
                    
                case .failure(_):
                    print("Item did not add to DB")
                   
                }
            },isFavourite: false)
        }
        
    }
    
    
    
    
    
    
}
