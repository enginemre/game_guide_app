//
//  GameViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation

class GameViewModel  {

    private let model = GameModel()
    
    
    // Data binding
    var onErrorOccurred : ((String) -> ())?
    
    var onDataRecived : (([GameCellItem]?)-> ())?
    
    var onNextDataRecived : (([GameCellItem]?) -> ())?
    
    func didViewLoad(){
        fetchData()
    }
    
    init(){
        model.delegate = self
    }
    
    func fetchData(){
        model.fetchData()
    }
    
    func fetchDataByOrderingRating(){
        model.fetchDataByOrderingRating()
    }
    
    func fetchDataByOrderingReleased(){
        model.fetchDataByOrderingReleased()
    }
    
    func fetchNextData(){
        model.fetchNextData()
    }
    
    func shouldShowIndic() -> Bool{
        return model.shouldShowIndic
    }
    
    
    func searchData(byText text:String){
        model.searchData(byText: text)
    }
    
    
}

extension GameViewModel : GameModelProtocol {
    func didDataFetch() {
        let gameCellItems :[GameCellItem] = model.data.map { game in
                .init(image: game.backgroundImage ?? "", title: game.name ?? "",id : game.id!)
        }
        onDataRecived?(gameCellItems)
    }
    
    func didDataNotFetch() {
        // TODO: Localization
        onErrorOccurred?("Please try again later".localized())
    }
    
    func didNextDataFetch() {
        let gameCellItems :[GameCellItem] = model.data.map { game in
                .init(image: game.backgroundImage ?? "", title: game.name ?? "",id: game.id!)
        }
        onNextDataRecived?(gameCellItems)
    }
    
    
}




