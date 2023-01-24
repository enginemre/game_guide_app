
import Foundation

struct GameDto: Codable {
    let count: Int?
    let next, previous: String?
    let results: [Game]?
    let seoTitle, description: String?

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case seoTitle = "seo_title"
        case description
    }
}

// MARK: - Game
struct Game: Codable {
    let id: Int?
    let slug, name, released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount, reviewsTextCount, metacritic, playtime: Int?
    let suggestionsCount: Int?
    let updated: String?
    let reviewsCount: Int?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let stores: [Store]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case reviewsCount = "reviews_count"
        case parentPlatforms = "parent_platforms"
        case genres, stores
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain
    }
}

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    let platform: Platform?
}

// MARK: - Platform
struct Platform: Codable {
    let id: Int?
    let name, slug: String?
}

// MARK: - Rating
struct Rating: Codable {
    let id: Int?
    let title: String?
    let count: Int?
    let percent: Double?
}

// MARK: - Store
struct Store: Codable {
    let id: Int?
    let store: Genre?
}
