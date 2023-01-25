//
//  Extensions.swift
//  game_guide_app
//
//  Created by Emre Muhammet Engin on 24.01.2023.
//

import Foundation


extension String {
    func localized() -> String{
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}

extension GameEntity {
    func toGameDetail() -> GameDetail {
        return GameDetail(id: Int(self.id), name: self.name, description: self.descriptions, released: self.released, updated: self.updatedDate, backgroundImage: self.imageUrl, backgroundImageAdditional: self.imageUrlAlt, website: self.website, rating: self.rating, ratingTop: Int(self.ratingTop),isFavourite: self.isFavourite, note: self.note ?? "")
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
