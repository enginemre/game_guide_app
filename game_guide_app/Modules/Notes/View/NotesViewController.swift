//
//  NotesViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class NotesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private let viewModel = NotesViewModel()
    
    private var tableViewHelper: NotesTableViewHelper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Notes".localized()
        viewModel.fetchData()
    }
    
    private func setupUI(){
        tableViewHelper = .init(tableView: tableView, viewModel: viewModel)
        tableViewHelper.delegate = self
    }
    
    private func setupSpinner(){
        tableView.isHidden = true
        indicator.startAnimating()
    }

    private func showContent(){
        tableView.isHidden = false
        indicator.stopAnimating()
    }

    private func setupBinding(){
        viewModel.onErrorOccurred = { [weak self] message in
            let alertController = UIAlertController(title: "Alert".localized(), message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok".localized(), style: .default))
            self?.present(alertController,animated: true)
            self?.indicator.stopAnimating()
        }
        viewModel.onDataRecived =  { [weak self] data in
            if let data = data{
                self?.tableViewHelper.setItems(
                    data.map({ game in
                        NotesCellItem(image: game.backgroundImage!, title: game.name!, note: game.note, id: game.id!)
                    })
                )
                self?.showContent()
            }
            
            
        }
    }
}


extension NotesViewController : NotesTableViewHelperDelegete {
    func pressedButton(_ cellItem: NotesCellItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let gameNotesVC = storyBoard.instantiateViewController(withIdentifier: "NoteAddViewController") as? NoteAddViewController{
            gameNotesVC.id = cellItem.id
            self.title = " "
            self.present(gameNotesVC, animated: true)
       
        }
    }
    
    
}

