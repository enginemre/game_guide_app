//
//  GameDetailViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 22.01.2023.
//

import UIKit
import Kingfisher


class GameDetailViewController: UIViewController {
    
    var id : Int? = nil
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var descriptionTilte: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let  viewModel = GameDetailViewModel()
    
    // Navigation bar items initializing
    private lazy var saveNoteBarItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(self.saveGame))
    private lazy var createNoteBarItem =  UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(self.createNote))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupSpinner()
        if let id = id {
            viewModel.didViewLoad(by: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Detail".localized()
    }
  
    
    private func setupUI(){
        saveNoteBarItem.tintColor = UIColor.white
        createNoteBarItem.tintColor = UIColor.white
        saveNoteBarItem.action = #selector(self.saveGame)
        createNoteBarItem.action = #selector(self.createNote)
        navigationItem.rightBarButtonItems = [createNoteBarItem,saveNoteBarItem]
    }
    
    private func setupSpinner(){
        detailView.isHidden = true
        gameImage.isHidden = true
        descriptionTilte.isHidden = true
        indicator.startAnimating()
    }
    
    private func showContent(){
        self.indicator.stopAnimating()
        detailView.isHidden = false
        gameImage.isHidden = false
        descriptionTilte.isHidden = false
    }
    

    @objc private func saveGame(){
        viewModel.favouriteStatusChange()
    }
    
    @objc private func createNote(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let gameNotesVC = storyBoard.instantiateViewController(withIdentifier: "NoteAddViewController") as? NoteAddViewController{
            gameNotesVC.id = id
            self.present(gameNotesVC, animated: true)
       
        }
    }

    // Changing navigation bar item icon according to game favourite status
    private func changeSaveItem(filled status : Bool){
        if(status){
             saveNoteBarItem =  UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(self.saveGame))
            saveNoteBarItem.tintColor = UIColor.white
            saveNoteBarItem.action = #selector(self.saveGame)
            createNoteBarItem.action = #selector(self.createNote)
        }else{
            saveNoteBarItem =  UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(self.saveGame))
            saveNoteBarItem.tintColor = UIColor.white
        }
        createNoteBarItem =  UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(self.createNote))
        createNoteBarItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [createNoteBarItem,saveNoteBarItem]
    }
}

private extension GameDetailViewController {
    
    func setupBinding(){
        viewModel.onErrorOccurred = { [weak self] message in
            self?.indicator.stopAnimating()
            let alertController = UIAlertController(title: "Alert".localized(), message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok".localized(), style: .default))
            self?.present(alertController,animated: true)
        }
        viewModel.onDataRecived =  { [weak self] data in
            if let data = data{
                self?.setUpContent(data)
                self?.showContent()
            }
        }
        viewModel.onDataFavouriteStatusChange = { [weak self]  status in
            self?.changeSaveItem(filled: status)
        }
    }
    
    func setUpContent(_ game: GameDetail){
        nameLabel.text = game.name
        ratingLabel.text = String( format: "%.1f", game.rating ?? 0.0)
        releasedLabel.text = game.released ?? "not known"
        updatedLabel.text = game.updated ?? "-"
        descriptionLabel.text = game.description
        changeSaveItem(filled: game.isFavourite)
        if let image = game.backgroundImage {
            gameImage.kf.setImage(with: URL.init(string: image))
        }else {
            gameImage.image = UIImage(named : "not-found-image")
        }
    }
    
    
}
