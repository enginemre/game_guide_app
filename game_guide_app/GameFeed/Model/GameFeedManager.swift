//
//  GameFeedManager.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation
import Alamofire

class GameFeedManager {
    
    static let shared = GameFeedManager()
    
    // Fetching all games from API
    func getAllGames(parameters:Parameters,complete : @escaping ((GameDto?,String?) -> ())){
        let url = "\(NetworkHelper.shared.baseUrl)\(Paths.games)"
        NetworkManager.shared.request(type: GameDto.self, url: url,parameters: parameters, method: HTTPMethod.get, completion: { (response) in
            switch response {
            case .success(let data) :
                complete(data,nil)
            case.failure(let error):
                complete(nil,error.rawValue)
            }
        })
    }
    
    // Fetching next page games from API
    func getNextData(url: String,complete : @escaping ((GameDto?,String?) -> ())){
        NetworkManager.shared.request(type: GameDto.self, url: url, parameters: nil,method: HTTPMethod.get, completion: { (response) in
            switch response {
            case .success(let data) :
                complete(data,nil)
            case.failure(let error):
                complete(nil,error.rawValue)
            }
        })
    }
    
    // Fetching game by id
    func getGame(by id : Int,parameters:Parameters, complete : @escaping ((GameDetail?,String?) -> ())){
        NetworkManager.shared.request(type: GameDetail.self, url: "\(NetworkHelper.shared.baseUrl)\(Paths.games)/\(id)", parameters: parameters, method: HTTPMethod.get,  completion: { (response) in
            switch response {
            case .success(let data) :
                complete(data,nil)
            case.failure(let error):
                complete(nil,error.rawValue)
            }
        })
    }
}
