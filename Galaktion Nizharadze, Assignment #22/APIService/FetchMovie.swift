//
//  FetchMovie.swift
//  Galaktion Nizharadze, Assignment #22
//
//  Created by Gaga Nizharadze on 13.08.22.
//

import Foundation


class TVShowFetch {
    
    static let shared = TVShowFetch()
    
    private let baseAPIURL = "https://api.themoviedb.org/3/tv/"
    private let urlSession = URLSession.shared
    
    let parameter = ["api_key": "07b3c5721acb723e40379334a99591ef"]
    
    private init() {}
    
    func fetchMovies<T: Codable>(from endpoint: EndPoint, completion: @escaping (T)->(Void)) {
        var urlComponents = URLComponents(string: baseAPIURL + endpoint.value)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                
                print(response!)
                return
            }
            
            if let error = error {
                
                print("\(error)")
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData)
                }
            }
            catch  {
                print(error)
                
            }
            
        }.resume()
    }
    
    
    func generateToken(completion: @escaping (Result<TokenModel, MovieError>) -> ()) {
        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/authentication/guest_session/new")
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                print(response!)
                return
            }
            
            if let error = error {
                completion(.failure(.serializationError))
                print("\(error)")
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TokenModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }
            catch  {
                print(error)
                completion(.failure(.apiError))
            }
            
        }.resume()
    }
    
    
    func addFeedback(id: String, feedback: Double, completion: @escaping (FeedbackModel)->(Void)) {
        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/tv/\(id)/rating")
        
        var queryItems = [URLQueryItem]()
        let feedbackParameter = ["api_key": "07b3c5721acb723e40379334a99591ef",
                                 "guest_session_id" : UserDefaults.standard.value(forKey: "token") as! String
        ]
        for (key, value) in feedbackParameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "POST"
        
        let body = ["value" : feedback]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                
                print(response!)
                return
            }
            
            if let error = error {
                
                print("\(error)")
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FeedbackModel.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData)
                }
            }
            catch  {
                print(error)
                
            }
            
        }.resume()
    }
}
