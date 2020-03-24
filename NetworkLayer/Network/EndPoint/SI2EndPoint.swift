//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 22/07/2019.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case local
    case develop
}

enum SI2Api {
	case dictionaries(types: [String])
    case averageVolume
    case mdataHistory
    case creditRating
	//case sendAppCenterPushToken(token: String)
    //case signup(AnyEncodable)//(SignUpRequest)
}

extension SI2Api: EndPointType {
    static let environment: NetworkEnvironment = .develop

    var environmentBaseURL: String {
        switch SI2Api.environment {
        case .local: return "http://localhost:8080"
        case .develop: return "https://185.157.97.135:443/api"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .dictionaries: return "dictionaries/get_dictionaries"
        case .averageVolume: return "instrument_average_volume"
        case .mdataHistory: return "instruments_mdata_history"
        case .creditRating: return "credit_rating"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .dictionaries,
             .mdataHistory,
			 .averageVolume,
             .creditRating:
            return .post
		}
	}
    
    var task: HTTPTask {
        switch self {
        case .mdataHistory,
			 .averageVolume,
             .creditRating:
            return .requestPlain
//		case .dictionaries(let types):
//			return .requestUrlParameters(["dictionary_types": types])
        case .dictionaries(let types):
            return .requestJSONEncodable(["dictionary_types": types])

        }
    }
    
    var headers: HTTPHeaders? {
        switch SI2Api.environment {
        case .develop, .local:
            return nil
//            return ["fakeResult": "checkedIn"]
        }
    }
}
