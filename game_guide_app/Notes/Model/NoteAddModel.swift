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
                self.data = game.toGameDetail()
                self.delegate?.didDataFetch()
            }
            
        }
    }
    
    
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
    
    
    func fetchGame(by id : Int){
        if(containData(id: id)){
            fetchGameFromDB(id: id)
        }else{
            fetchGameFromAPI(by: id)
        }
    }
    
    func updateNote(note : String){
        if let game = data {
            if(coreDataManager.containData(id: game.id!)){
                coreDataManager.updateGame(id: game.id!, note: note, favourite: game.isFavourite) { res in
                    switch(res){
                    case .success(_):
                        self.data?.note = note
                        self.delegate?.didDataUpdate()
                    case .failure(_):
                        self.delegate?.didDataNotUpdate()
                    }
                }
            }else{
                coreDataManager.saveGame(game, note, completion:  { res in
                    switch(res){
                    case .success(_):
                        self.data?.note = note
                        self.delegate?.didDataUpdate()
                    case .failure(_):
                        self.delegate?.didDataNotUpdate()
                    }
                }, isFavourite : game.isFavourite)
            }
            
        }
    }
    
    
}

