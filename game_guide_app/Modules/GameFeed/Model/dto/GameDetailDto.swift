//
//  GameDetailDto.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 22.01.2023.
//


import Foundation

// MARK: - GameDetail
struct GameDetail: Codable {
    let id: Int?
    let name, description: String?
    let released: String?
    let updated: String?
    let backgroundImage, backgroundImageAdditional: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    var isFavourite : Bool = false
    var note : String = ""

    enum CodingKeys: String, CodingKey {
        case id, name
        case  released, updated
        case description = "description_raw"
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case ratingTop = "rating_top"
    }
}



