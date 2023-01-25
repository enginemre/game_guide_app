//
//  FilterViewCell.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 25.01.2023.
//

import UIKit

class FilterViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var filterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
