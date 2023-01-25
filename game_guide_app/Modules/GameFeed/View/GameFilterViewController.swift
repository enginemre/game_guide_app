//
//  GameFilterViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 25.01.2023.
//

import UIKit
import PanModal

class GameFilterViewController: UIViewController {
    
    private let viewModel = GameFilterViewModel()
    
    var selectionCallBack : ((Int)->())?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
    }
    
    private func setupUI(){
        let cell = UINib(nibName: "FilterViewCell",
                                     bundle: nil)
        tableView?.register(cell,
                                   forCellReuseIdentifier: "FilterViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension GameFilterViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            self?.selectionCallBack?((self?.viewModel.items[indexPath.row].id)!)
        }
    
    }
    
}

extension GameFilterViewController  : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath) as! FilterViewCell
        cell.filterName.text = viewModel.items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    
    
}

extension GameFilterViewController : PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight{
        return .contentHeight(150)	
    }
}
