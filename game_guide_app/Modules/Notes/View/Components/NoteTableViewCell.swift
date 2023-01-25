//
//  NoteTableViewCell.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNote: UILabel!

    @IBOutlet weak var gameName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Styling cell corner
        cellView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Configuring cell item
    func configureItem(item : NotesCellItem){
        gameNote.text = item.note
        gameName.text = item.title
        gameImage.kf.setImage(with: URL.init(string: item.image))
    }
}

struct NotesCellItem {
    let image : String
    let title : String
    let note : String
    var id : Int
}
