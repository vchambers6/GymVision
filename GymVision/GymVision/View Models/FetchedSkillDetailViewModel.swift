//
//  FetchedSkillDetailViewModel.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/4/24.
//

import SwiftUI


class FetchedSkillDetailViewModel: ObservableObject {
    @Published var skill: Skill?
    
    func fetchSkill(at uuidString: String) async throws {
        let urlString = Constants.baseURL + Endpoints.skills + uuidString
        
        print("🤸🏾‍♂️ \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badUrl
        }
        
        
        let skillResponse: Skill = try await HttpClient.shared.fetchSingle(url: url)
        
        DispatchQueue.main.async {
            self.skill = skillResponse
        }
    }
}
