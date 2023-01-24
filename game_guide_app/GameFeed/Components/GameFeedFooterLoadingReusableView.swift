//
//  GameFeedFooterLoadingReusableView.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 18.01.2023.
//

import UIKit

final class GameFeedFooterLoadingReusableView: UICollectionReusableView {
    static let identifier = "GameFeedFooterLoadingReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(named: "MainColor")
        return spinner
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(spinner)
        addConstraint()
    }
    
    private func addConstraint(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func startAnimating(){
        spinner.startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("UnSuported Error")
    }
}
