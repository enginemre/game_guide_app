//
//  NotesTableViewHelper.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation
import UIKit


protocol NotesTableViewHelperDelegete : AnyObject{
    
    func pressedButton(_ cellItem : NotesCellItem)
    
}


class NotesTableViewHelper : NSObject{
    
    typealias RowItem = NotesCellItem
    
    private let cellIdentifier = "NoteTableViewCell"
    
    weak var delegate : NotesTableViewHelperDelegete?
    
    weak var tableView : UITableView?
    weak var viewModel : NotesViewModel?
    
    private var items : [RowItem] = []
    
    
    init(tableView: UITableView, viewModel : NotesViewModel){
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
        tableView?.delegate = self
        let cell = UINib(nibName: "NoteTableViewCell",
                                     bundle: nil)
        tableView?.register(cell,
                                   forCellReuseIdentifier: "NoteTableViewCell")
        
    }
}


extension NotesTableViewHelper : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        cell.configureItem(item: items[indexPath.item])
        return cell
    }
    
    
}

extension NotesTableViewHelper : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.pressedButton(item)
    }
}
