//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 22/07/2019.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestUrlParameters([String: Any])
    case requestCompositeParameters(bodyEncodable: Encodable, urlParameters: [String: Any])
}
