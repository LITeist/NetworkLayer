//
//  URLRequest+ParametersEncoding.swift
//  Parking
//
//  Created by Konstantin Elizarov on 9/20/19.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func addJSONBody(_ encodable: Encodable) throws {
        let anyEncodable = AnyEncodable(encodable)
        let data = try JSONEncoder().encode(anyEncodable)
        httpBody = data
    }
    
    mutating func addUrlParameters(_ parameters: [String: Any]) {
        
        guard let url = self.url else { return }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            self.url = urlComponents.url
        }
    }
}
