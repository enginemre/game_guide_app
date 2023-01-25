//
//  GameDetailViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 22.01.2023.
//

import Foundation

class GameDetailViewModel {
    private let model = GameDetailModel()
    
    
    // Data Binding
    
    var onErrorOccurred : ((String) -> ())?
    
    var onDataRecived : ((GameDetail?)-> ())?
    
    var onDataFavouriteStatusChange : ((Bool)->())?
    
    func didViewLoad(by id :Int){
        fetchData(by : id)
    }
    
    init(){
        model.delegate = self
    }
    
    
    func fetchData(by id : Int){
        if(model.containData(id: id)){
            model.fetchGameFromDB(id: id)
        }else {
            model.fetchGameFromAPI(by: id )
        }
        
    }
    
    func favouriteStatusChange(){
        model.setFavourite()
    }
}

extension GameDetailViewModel : GameDetailProtocol {
    func didDataFavourite(_ status: Bool) {
        if var data = model.data {
            data.isFavourite = status
            onDataFavouriteStatusChange?(status)
        }
    }
    
    func didDataFetch() {
        guard let data = model.data else {
            onErrorOccurred?("Game detail did not fetch".localized())
            return
        }
        onDataRecived?(data)
    }
    
    func didDataNotFetch() {
        onErrorOccurred?("Please try again later".localized())
    }
    
    
}

