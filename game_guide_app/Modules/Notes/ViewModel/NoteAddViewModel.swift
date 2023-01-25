//
//  NoteAddViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation


class NoteAddViewModel {
    
    private let model = NoteAddModel()
    
    // Data Binding
    var onErrorOccurred : ((String) -> ())?
    
    var onDataRecived : ((GameDetail?)-> ())?
    
    var onUpdateCompleted : ((GameDetail?)-> ())?
    
    func didViewWillAppear(by id :Int){
        fetchData(by : id)
    }
    
    init(){
        model.delegate = self
    }
    
    func fetchData(by id : Int){
        if (model.containData(id: id)){
            model.fetchGameFromDB(id: id)
        }else {
            model.fetchGameFromAPI(by: id)
        }
    }
    
    func updateData(note : String){
        model.updateNote(note: note)
    }
    
}

extension NoteAddViewModel : NoteAddDelegate{
    
    func didDataUpdate() {
        LocalNotificationManager.setNotification(1, title: "Note Updated".localized(), body: "Note was successfully updated".localized())
        onUpdateCompleted?(model.data)
    }
    
    func didDataNotUpdate() {
        onErrorOccurred?("Note did not updated please try again later".localized())
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
