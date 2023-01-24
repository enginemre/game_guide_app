//
//  NoteAddViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import UIKit

class NoteAddViewController: UIViewController {

    private let viewModel = NoteAddViewModel()
    
    var id : Int? = nil
    
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameNote: UITextField!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var noteAddSaveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        if let id = id{
            viewModel.didViewWillAppear(by: id)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Localization
        self.title = "Detail"
    }
  

    @IBAction func noteAddSave(_ sender: Any) {
        viewModel.updateData(note: gameNote.text ?? "")
    }
    
    private func setupUI(){
        // TODO: Show indic
        // TODO: Localization
    }
}


private extension NoteAddViewController {
    func setupBinding(){
        viewModel.onErrorOccurred = { [weak self] message in
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok", style: .default))
            self?.present(alertController,animated: true)
        }
        viewModel.onDataRecived =  { [weak self] data in
            if let data = data{
                self?.setUpContent(data)
            }
            
        }
        viewModel.onUpdateCompleted = { [weak self] data in
            if let data = data {
                self?.setUpContent(data)
                print("Update completed")
            }
            print("Update did not completed")
           
        }
    }
    
    func setUpContent(_ game : GameDetail){
        gameTitle.text = game.name
        if(!(game.note.isEmpty)){
            gameNote.text = game.note
            noteAddSaveButton.setTitle("Update", for: .normal)
        }
        if let image = game.backgroundImage {
            gameImage.kf.setImage(with: URL.init(string: image))
        }else {
            gameImage.image = UIImage(named : "not-found-image")
        }
    }
}
