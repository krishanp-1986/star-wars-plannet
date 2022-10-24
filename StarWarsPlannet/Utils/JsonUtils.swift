//
//  JsonUtils.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation

struct JsonUtils {
    static func convertJsonIntoDecodable<T>(
        _ type: T.Type,
        fileName: String,
        bundle: Bundle = .main,
        inDirectory: String? = "MockResponse"
    ) -> T? where T: Decodable {
        guard let filePath = bundle.path(forResource: fileName, ofType: "json", inDirectory: inDirectory) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
