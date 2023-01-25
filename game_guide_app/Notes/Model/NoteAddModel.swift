//
//  NoteAddModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation


protocol NoteAddDelegate : AnyObject {
    func didDataFetch()
    func didDataNotFetch()
    
    func didDataUpdate()
    func didDataNotUpdate()
}


class NoteAddModel {

    private(set) var data : GameDetail?
    
    weak var delegate : NoteAddDelegate?
    
    private let coreDataManager = CoreDataManager(game: "game_guide_app")
    
    private let gameFeedManager = GameFeedManager()
    
    
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
    
    
    func fetchGame(by id : Int){
        
        
        coreDataManager.getGameBy(id: id) { res in
            switch(res){
            case .success(let data):
                guard let games = data else {
                    self.delegate?.didDataNotFetch()
                    return
                }
                self.data =
                GameDetail(id: Int(games.id), name: games.name ?? "", description: games.descriptions ?? "", released: games.released ?? "", updated: games.updatedDate ?? "", backgroundImage: games.imageUrl ?? "", backgroundImageAdditional: games.imageUrlAlt ?? "",  website: games.website ?? "", rating: games.rating , ratingTop: Int(games.ratingTop ))
                
                self.delegate?.didDataFetch()
            case .failure(_):
                self.delegate?.didDataNotFetch()
            }
        }
    }
    
    func updateNote(note : String){
        if let game = data {
            coreDataManager.updateGame(id: game.id!, note: game.note, favourite: game.isFavourite) { res in
                switch(res){
                case .success(_):
                    self.data?.note = note
                    self.delegate?.didDataUpdate()
                case .failure(_):
                    self.delegate?.didDataNotUpdate()
                }
            }
        }
    }
    
    
}

