//
//  NoteAddViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import UIKit

protocol NoteAddViewDelegate : AnyObject{

    func didDataUpdated()
}

class NoteAddViewController: UIViewController {

    private let viewModel = NoteAddViewModel()
    
    var id : Int? = nil
 
    
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameNote: UITextField!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var noteAddSaveButton: UIButton!
    @IBOutlet weak var noteTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupSpinner()
        if let id = id{
            viewModel.didViewWillAppear(by: id)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Detail".localized()
    }
  
    private func setupSpinner(){
        noteTitle.isHidden = true
        gameTitle.isHidden = true
        gameNote.isHidden = true
        gameImage.isHidden = true
        noteAddSaveButton.isHidden = true
        indicator.startAnimating()
    }

    private func showContent(){
        noteTitle.isHidden = false
        gameTitle.isHidden = false
        gameNote.isHidden = false
        gameImage.isHidden = false
        noteAddSaveButton.isHidden = false
        indicator.stopAnimating()
    }

    @IBAction func noteAddSave(_ sender: Any) {
        viewModel.updateData(note: gameNote.text ?? "")
    }
    
}


private extension NoteAddViewController {
    func setupBinding(){
        viewModel.onErrorOccurred = { [weak self] message in
            let alertController = UIAlertController(title: "Alert".localized(), message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok".localized(), style: .default))
            self?.present(alertController,animated: true)
            self?.indicator.stopAnimating()
        }
        viewModel.onDataRecived =  { [weak self] data in
            if let data = data{
                self?.setUpContent(data)
                self?.showContent()
            }
            
        }
        viewModel.onUpdateCompleted = { [weak self] data in
            if let data = data {
                self?.setUpContent(data)
                self?.dismiss(animated: true)
            }
           
        }
    }
    
    func setUpContent(_ game : GameDetail){
        gameTitle.text = game.name
        if(!(game.note.isEmpty)){
            gameNote.text = game.note
            noteAddSaveButton.setTitle("Update".localized(), for: .normal)
        }else {
            noteAddSaveButton.setTitle("Add Note".localized(), for: .normal)
        }
        if let image = game.backgroundImage {
            gameImage.kf.setImage(with: URL.init(string: image))
        }else {
            gameImage.image = UIImage(named : "not-found-image")
        }
    }
}
