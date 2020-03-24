//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 22/07/2019.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
