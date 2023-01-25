//
//  GameFilterViewModel.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 25.01.2023.
//
import Foundation

class GameFilterViewModel {
    var items = [FilterItem(id: 1, title: "Order By Released".localized()) ,FilterItem(id: 2, title: "Order By Rating".localized()),FilterItem(id: 3, title: "Clear".localized())]
}

struct FilterItem {
    var id :  Int
    var title : String
}
