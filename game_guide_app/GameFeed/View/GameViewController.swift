//
//  GameViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class GameViewController: BaseViewController {
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
    }
    
    private func setupUI(){
        navigationItem.title = "Game Guide"
        // Customizing searchBar
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        // TODO: Localizaiton
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = UIColor(named: "OnSurface")
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedText =  NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
          
    }
    
    
    
    @objc  private func showSearchBar(){
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    @objc private func showFilterScreen(){
        
    }
    // Show search bar and hide other items
    private func showSearchBarButton( shouldShow : Bool){
        if shouldShow{
            let searchItem =  UIBarButtonItem(barButtonSystemItem: .search,target : self, action: #selector(showSearchBar))
            searchItem.tintColor = UIColor.white
            let filterItem =  UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: nil, action: #selector(showFilterScreen))
            filterItem.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = filterItem
            navigationItem.rightBarButtonItem = searchItem
        }else {
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    // Decide components according to shouldShow
    private func search(shouldShow : Bool){
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    
    
}

   


extension GameViewController : UISearchBarDelegate {
 
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow : false)

    }
}


