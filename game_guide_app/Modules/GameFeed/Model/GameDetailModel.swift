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
        let parameters = NetworkHelper.shared.parameters
        gameFeedManager.getGame(by: id, parameters: parameters) { data, message in
            guard let game = data else {
                self.delegate?.didDataNotFetch()
                return
            }
            self.data = game
            self.delegate?.didDataFetch()
        }
        
    }
    // Checking core data is contains game
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
                // Converting GameEntity to GameDetail
                self.data = game.toGameDetail() 
                self.delegate?.didDataFetch()
            }
            
        }
    }
    
    func setFavourite(){
        let favourite = data?.isFavourite ?? false
        if let data = data {
            // if doesn't contain data add to db otherwise update
            if(coreDataManager.containData(id: data.id!)){
                coreDataManager.updateGame(id: data.id!, note: data.note, favourite: !favourite) { res in
                    switch(res){
                        case .success(_):
                            self.data?.isFavourite = !favourite
                            self.delegate?.didDataFavourite(!favourite)
                        case .failure(_):
                            print("Error ocurred while favouriting item")
                            self.data?.isFavourite = favourite
                            self.delegate?.didDataFavourite(favourite)
                    }
                }
            }else{
                coreDataManager.saveGame(data, "", completion: { res in
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
