//
//  DetailsModel.swift
//  Galaktion Nizharadze, Assignment #22
//
//  Created by Gaga Nizharadze on 13.08.22.
//

import Foundation

struct TVShowDetails: Decodable {
    let backdropPath: String?
    let episodeRunTime: [Int]
    let firstAirDate: String
    let genres: [Genre]
    let id: Int
    let languages: [String]
    let lastAirDate: String
    let name: String
    let numberOfEpisodes, numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, id
        case languages
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    
    var backdropURLString: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath ?? posterPath)"
    }
    
    var posterURLString: String {
        return  "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0 ..< (rating / 2)).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        
        return ratingText
    }
    
    // MARK: - Genre
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
}



struct FeedbackModel: Codable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
