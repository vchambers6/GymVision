//
//  SearchViewModel.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/2/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var skills: [Skill] = []
    
    @Published var queryString: String = ""
    
    
     func getSkills() async throws {
        
        let encodedQueryString = queryString.replacingOccurrences(of: " ", with: "%20")
        let urlString = Constants.baseURL + Endpoints.skills + Endpoints.search + encodedQueryString
        
        print("🤸🏾‍♂️ \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badUrl
        }
        
        
        let skillResponse: [Skill] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.skills = skillResponse
        }
    }
}
