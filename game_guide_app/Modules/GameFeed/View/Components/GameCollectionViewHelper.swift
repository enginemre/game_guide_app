//
//  GameCollectionViewHelper.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import Foundation
import UIKit



protocol GameCollectionViewHelperDelegete : AnyObject{
    
    func pressedButton(_ cellItem : GameCellItem)
    
}

class GameCollectionViewHelper : NSObject {
    
    typealias RowItem = GameCellItem

    private let cellIdentifier = "GameFeedCell"
    
    // Currently next page data is loading
    var isLoadingMoreGames = false
    
    weak var delegate : GameCollectionViewHelperDelegete?
    
    weak var view : UIView?
    weak var collectionView : UICollectionView?
    weak var viewModel : GameViewModel?
    
    private var items : [RowItem] = []
    
    init(collectionView: UICollectionView, viewModel : GameViewModel,view : UIView){
        self.viewModel = viewModel
        self.collectionView = collectionView
        self.view = view
        super.init()
        setupCollectionView()
        setupBindings()
    }
    
    // Reloading table view with new data
    func setItems(_ items : [RowItem]){
        self.items = items
        collectionView?.reloadData()
    }
    
    private func setupCollectionView(){
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // Animation for collection view
        collectionView?.isHidden = true
        collectionView?.alpha = 0
        collectionView?.register(UINib(nibName: "GameFeedCell", bundle: nil), forCellWithReuseIdentifier:cellIdentifier)
        collectionView?.register(GameFeedFooterLoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GameFeedFooterLoadingReusableView.identifier)
    }
}


extension GameCollectionViewHelper : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Setting footer for indicator
        guard kind == UICollectionView.elementKindSectionFooter else {
             fatalError("UNSUPPORTED")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GameFeedFooterLoadingReusableView.identifier, for: indexPath) as! GameFeedFooterLoadingReusableView
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Footer height adjusting if is there a data
        if let shouldShow = viewModel?.shouldShowIndic() {
            guard  shouldShow else{
                return .zero
            }
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameFeedCell", for: indexPath) as! GameFeedCell
        // Configuring cell item
        cell.cofigureCell(with: items[indexPath.item])
        cell.gameImage.kf.setImage(with: URL.init(string: items[indexPath.item].image))
        return cell
    }
    
    
}

extension GameCollectionViewHelper : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        delegate?.pressedButton(item)
    }
    
}

extension GameCollectionViewHelper : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculating item count on screen according to screen width
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2
        return CGSize(width: size, height: size)
    }
   
    
}

extension GameCollectionViewHelper : UIScrollViewDelegate {
    
    // Fetching next page data
    private func fetchNextData(){
        // Canceling if already loading
        guard !(self.isLoadingMoreGames) else{
            return
        }
        self.isLoadingMoreGames = true
        self.viewModel?.fetchNextData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let shouldShow = viewModel?.shouldShowIndic()  {
            guard shouldShow, !isLoadingMoreGames, !items.isEmpty else {
                return
            }
            // Prevent a bug with some delay
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
                let offset = scrollView.contentOffset.y
                let totalHeight = scrollView.contentSize.height
                let totalContentFixedHeight = scrollView.frame.size.height
                // Next data fetch triggering
                if(offset >= (totalHeight - totalContentFixedHeight - 120)){
                    self?.fetchNextData()
                }
                t.invalidate()
            }
           
        }
    }
}

private extension GameCollectionViewHelper {
    
    func setupBindings(){
        viewModel?.onNextDataRecived =  { [weak self] data in
            
            // Next data fetched update item and isloading false
            self?.isLoadingMoreGames = false
            self?.setItems(data!)
        }
    }
}

