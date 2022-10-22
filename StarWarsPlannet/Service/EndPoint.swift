//
//  EndPoint.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation

enum EndPoint {
    private static let baseUrl = "https://swapi.dev/api/planets"
    
    case loadPlanet(String?)
    
    private var httpMethod: String {
        "GET"
    }
    
    var request: URLRequest? {
        var url = Self.baseUrl
        switch self {
        case .loadPlanet(let planetUrl):
            if let urlToLoad = planetUrl {
                url = urlToLoad
            }
        }
        
        guard let requestURL = URL(string: url) else { return nil }
        var request = URLRequest(url: requestURL)
        request.httpMethod = self.httpMethod
        return request
    }
}
