//
//  FavouritesViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class FavouritesViewController: BaseViewController {

    private let viewModel =  FavouriteViewModel()
    
    private var tableViewHelper : FavouritesTableViewHelper!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavourites()
    }
    
    
    private func setupUI(){
        self.title = "Favourites"
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
                        FavouriteCellItem(image: game.backgroundImage ?? "", title: game.name ?? "", released: game.released ?? "", rating: String(game.rating ?? 0.0), id: game.id!)
                    })
                )
            }
            
        }
    }
}
