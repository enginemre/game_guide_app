//
//  GameViewController.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 13.01.2023.
//

import UIKit

class GameViewController: BaseViewController {
    
    private let estimateWith = 160.0
    private let cellMarginSize = 16.0
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
    }
    
    private func setupUI(){
        navigationItem.title = "Game Guide"
        // Customizing searchBar
        setupSearchBar()
        setupCollectionView()
        setupSpinner()
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
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(UINib(nibName: "GameFeedCell", bundle: nil), forCellWithReuseIdentifier: "GameFeedCell")
        let flow = collectionView.collectionViewLayout  as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
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

    }
}

extension GameViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameFeedCell", for: indexPath) as! GameFeedCell
        return cell
    }
    
    
}

extension GameViewController : UICollectionViewDelegate{
    
}

extension GameViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width * 1.5 )
    }
    
    func calculateWith() -> CGFloat {
        let estimateWidth = CGFloat(estimateWith)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimateWidth)
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        return width
    }
    
}
