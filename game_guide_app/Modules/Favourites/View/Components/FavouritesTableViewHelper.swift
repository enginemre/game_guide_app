//
//  FavouritesTableViewHelper.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 23.01.2023.
//

import Foundation
import UIKit


class FavouritesTableViewHelper : NSObject {
    
    typealias RowItem = FavouriteCellItem
    
    private let cellIdentifier = "FavouritesCell"
    
    weak var tableView : UITableView?
    weak var viewModel : FavouriteViewModel?
    
    private var items : [RowItem] = []
    
    
    init(tableView: UITableView, viewModel : FavouriteViewModel){
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    func setItems(_ items : [RowItem]){
        self.items = items
        tableView?.reloadData()
    }
    
    private func setupTableView(){
        tableView?.dataSource = self
        let cell = UINib(nibName: "FavouriteTableViewCell",
                                     bundle: nil)
        tableView?.register(cell,
                                   forCellReuseIdentifier: "FavouriteTableViewCell")
        
    }

}

extension FavouritesTableViewHelper : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
        cell.configureItem(item: items[indexPath.item])
        return cell
    }
    
    
}
