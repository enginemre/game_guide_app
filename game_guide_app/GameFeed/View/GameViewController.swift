//
//  GameViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class GameViewController: BaseViewController {
    

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    private var collectionHelper : GameCollectionViewHelper!
    private let viewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
    
  
    
    private func setupSpinner(){
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.indicator.stopAnimating()
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.collectionView.alpha = 1
            })
        })
    }
    
    // MARK: SEARCHBAR
    private func setupSearchBar(){
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(named: "OnSurface")
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            // TODO: Localizaiton
            string: "Arama",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font : UIFont(name: "Sk-Modernist-Regular", size: 16)!]
        )
        searchBar.searchTextField.attributedText =  NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont(name: "Sk-Modernist-Regular", size: 16)!]
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
        viewModel.fetchData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchData(byText:searchBar.text ?? "")
    }
}

private extension GameViewController {
        
    private func setupUI(){
        navigationItem.title = "Game Guide"
        collectionHelper = .init(collectionView: collectionView, viewModel: viewModel, view: self.view)
        // Customizing searchBar
        setupSearchBar()
        setupSpinner()
    }
    
    func setupBindings(){
        viewModel.onErrorOccurred = { [weak self] message in
            self?.collectionHelper.isLoadingMoreGames = false
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(.init(title: "Ok", style: .default))
            self?.present(alertController,animated: true)
        }
        viewModel.onDataRecived =  { [weak self] data in
            self?.collectionHelper.setItems(data!)
        }
    }
}
