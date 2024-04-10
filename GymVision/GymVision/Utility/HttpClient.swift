//
//  HttpClient.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/1/24.
//

import Foundation

// singleton class -- doesn't have an initializer, but we
// can access it through the shared property
// You use singletons to provide a globally accessible, shared instance of a class.

enum HttpError: Error {
    case badUrl, badResponse, errorDecodingData, invalidURL
}

class HttpClient {
    private init() { }
    
    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // check to see if HTTPURL response was a good resposne
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let object = try decoder.decode([T].self, from:  data)
            return object
            // Handle decoded skill object
        } catch {
            print("Error decoding JSON data:", error)
        }
        guard let object = try? decoder.decode([T].self, from:  data) else {
            throw HttpError.errorDecodingData
        }
        
        return object
    }
    
    func fetchSingle<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // check to see if HTTPURL response was a good resposne
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        // MARK: I think this is where things are going wrong. JSON decoding is not working for some reason
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let object = try? decoder.decode(T.self, from:  data) else {
            throw HttpError.errorDecodingData
        }
        
        return object
    }
    
}
