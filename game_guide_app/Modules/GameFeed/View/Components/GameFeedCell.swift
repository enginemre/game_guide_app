//
//  GameFeedCell.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import UIKit
import Kingfisher

class GameFeedCell: UICollectionViewCell {
    
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Styling cell view corner
        gameView.layer.cornerRadius = 8
    }
    
    // Configuring cell
    func cofigureCell(with item : GameCellItem){
        gameTitle.text = item.title
    }

}


struct GameCellItem {
    let image : String
    let title : String
    var id : Int
}

