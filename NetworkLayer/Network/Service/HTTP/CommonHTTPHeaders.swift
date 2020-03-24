//
//  CommonHTTPHeaders.swift
//  Parking
//
//  Created by Konstantin Elizarov on 9/9/19.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

enum CommonHTTPHeaders {
    case contentTypeApplicationJson
    case contentTypeUrlEncoded
    case authorization(token: String)

    var name: String {
        switch self {
        case .contentTypeApplicationJson,
            .contentTypeUrlEncoded:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .contentTypeApplicationJson:
            return "application/json"
        case .contentTypeUrlEncoded:
            return "application/x-www-form-urlencoded; charset=utf-8"
        case .authorization(let token):
            return "Bearer \(token)"
        }
    }
}
