//
//  NotesViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation

class NotesViewModel{
    
    private let model  = NotesModel()
    
    
    // Data Binding
    
    var onErrorOccurred : ((String) -> ())?
    
    var onDataRecived : (([GameDetail]?)-> ())?
    
    
    
    func didViewWillAppear(){
        fetchData()
    }
    
    init(){
        model.delegate = self
    }
    
    func fetchData(){
        model.fetchData()
    }
    
    
    
}

extension NotesViewModel : NotesModelDelegate {
    
    
    func didDataFetch() {
        onDataRecived?(model.data)
    }
    
    func didDataNotFetch() {
        // TODO: Localization
        onErrorOccurred?("Please try again later")
    }
    
    
}
