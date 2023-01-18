//
//  GameFeedCell.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import UIKit

class GameFeedCell: UICollectionViewCell {
    
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        gameView.layer.cornerRadius = 16
    }

}
