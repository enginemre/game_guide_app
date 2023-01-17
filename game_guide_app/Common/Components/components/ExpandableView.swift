//
//  ExpandableView.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 17.01.2023.
//

import UIKit


class ExpandableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
