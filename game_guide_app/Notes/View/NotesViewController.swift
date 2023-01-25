//
//  NotesViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class NotesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = NotesViewModel()
    
    private var tableViewHelper: NotesTableViewHelper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    private func setupUI(){
        self.title = "Notes"
        tableViewHelper = .init(tableView: tableView, viewModel: viewModel)
    }


    private func setupBinding(){
        viewModel.onErrorOccurred = { [weak self] message in
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok", style: .default))
            self?.present(alertController,animated: true)
        }
        viewModel.onDataRecived =  { [weak self] data in
            if let data = data{
                self?.tableViewHelper.setItems(
                    data.map({ game in
                        NotesCellItem(image: game.backgroundImage!, title: game.name!, note: game.note, id: game.id!)
                    })
                )
            }
            
        }
    }
}
