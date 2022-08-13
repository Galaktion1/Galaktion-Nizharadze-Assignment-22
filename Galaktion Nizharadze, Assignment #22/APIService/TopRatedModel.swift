//
//  TopRatedModel.swift
//  Galaktion Nizharadze, Assignment #22
//
//  Created by Gaga Nizharadze on 13.08.22.
//

//   let topRatedShows = try? newJSONDecoder().decode(TopRatedShows.self, from: jsonData)

import Foundation

// MARK: - UniónDeNacionesSuramericanas
struct TopRatedShows: Codable {
    let results: [TVShow]
}

// MARK: - Result
struct TVShow: Codable {
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int
    
    var isFavourite = false

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    
    private var baseURLForImages = "https://image.tmdb.org/t/p/w500"
    var backdropURLString: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")"
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
}


import Foundation

protocol MovieService {
    
    func fetchMovies(from endpoint: EndPoint, completion: @escaping (Result<TopRatedShows, MovieError>) -> ())
    
}


enum EndPoint {
    case id(String)
    case topRated
    
    var value: String {
        switch self {
        case .topRated:
            return "top_rated"
        case .id(let customValue):
            return customValue
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}


// MARK: - TokenResponse
struct TokenModel: Codable {
    let success: Bool
    let guestSessionID, expiresAt: String

    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
