//
//  AnyEncodable.swift
//  Connect
//
//  Created by Konstantin Elizarov on 9/17/19.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
