//
//  FavouriteTableViewCell.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 23.01.2023.
//

import UIKit
import Kingfisher

class FavouriteTableViewCell: UITableViewCell {


    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageFavourite: UIImageView!
    @IBOutlet weak var releasedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        cellView.layer.cornerRadius = 8
    }
    
    func configureItem(item : FavouriteCellItem){
        ratingLabel.text = item.rating
        nameLabel.text = item.title
        imageFavourite.kf.setImage(with: URL.init(string: item.image))
        releasedLabel.text = item.released
    }
}


struct FavouriteCellItem {
    let image : String
    let title : String
    let released : String
    let rating : String
    var id : Int
}
