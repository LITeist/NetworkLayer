//
//  URLRequest+CommonHeaders.swift
//  Parking
//
//  Created by Konstantin Elizarov on 9/20/19.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func addHeader(_ header: CommonHTTPHeaders) {
        setValue(header.value, forHTTPHeaderField: header.name)
    }
    
    mutating func addHeaders(_ headers: [CommonHTTPHeaders]) {
        headers.forEach({ addHeader($0) })
    }
    
    mutating func addHeaders(_ additionalHeaders: [String: String]?) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}
