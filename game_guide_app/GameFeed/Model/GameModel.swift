//
//  GameModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation

protocol GameModelProtocol : AnyObject{
    func didDataFetch()
    
    func didDataNotFetch()
    
    func didNextDataFetch()
}


class GameModel {
    
    private(set) var data : [Game]  = []
    
    var shouldShowIndic :Bool = false
    
    var nextUrl: String? 
    
    weak var delegate : GameModelProtocol?
    
    private let gameFeedManager = GameFeedManager()
    
    func fetchData(){
        var parameters = NetworkHelper.shared.parameters
        parameters["page"] =  "1"
        gameFeedManager.getAllGames(parameters: parameters , complete: { data,error in
            guard let game = data else {
                self.delegate?.didDataNotFetch()
                return
            }
            self.data = game.results ?? []
            self.shouldShowIndic = game.next != nil
            self.nextUrl = game.next
            self.delegate?.didDataFetch()
            
        })
    }

    func fetchNextData(){
        if let url = nextUrl {
            gameFeedManager.getNextData(url: url) { game, message in
                guard let data = game else{
                    self.delegate?.didDataNotFetch()
                    return
                }
                self.data.append(contentsOf: data.results ?? [])
                self.shouldShowIndic = data.next != nil
                self.nextUrl = data.next
                self.delegate?.didNextDataFetch()
            }
        }else {
            self.delegate?.didDataNotFetch()
        }
        
    }

    func searchData(byText text:String){
        var parameters = NetworkHelper.shared.parameters
        parameters["search"] = text
        gameFeedManager.getAllGames(parameters: parameters) { game, message in
            guard let data = game else{
                self.delegate?.didDataNotFetch()
                return
            }
            self.data = data.results ?? []
            self.shouldShowIndic = data.next != nil
            self.nextUrl = data.next
            self.delegate?.didNextDataFetch()
        }

    }
    
    
    
}
