//
//  NotesModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation


protocol NotesModelDelegate : AnyObject {
    
    func didDataFetch()
    
    func didDataNotFetch()
    
}

class NotesModel {
    
    private(set) var data : [GameDetail] = []
    
    weak var delegate : NotesModelDelegate?
    
    private let coreDataManager = CoreDataManager(game: "game_guide_app")
    
    
    func fetchData(){
        coreDataManager.getAllNotes {  res in
            switch(res){
            case .success(let data):
                guard let noteList = data else {
                    self.delegate?.didDataNotFetch()
                    return
                }
                self.data =  noteList.map { entity in
                    entity.toGameDetail()
                }
                self.delegate?.didDataFetch()
            case .failure(_):
                self.delegate?.didDataNotFetch()
            }
        }
    }
    
    
}
