//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 22/07/2019.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

enum Result<ResultType, ErrorType: Error> {
    case success(ResultType)
    case failure(ErrorType)
}

final class NetworkManager {
    static let SI2APIKey = ""
    let router = Router<SI2Api>()
    
    func getAverageVolume(completion: @escaping (_ result: RouterRequestResult) -> Void) {
		router.request(.averageVolume) { (result) in
			completion(result)
        }
    }
	
	func getDictionaries(types: [String], completion: @escaping (_ result: RouterRequestResult) -> Void) {
		router.request(.dictionaries(types: types)) { (result) in
			completion(result)
        }
    }
	
	func getMdataHistory(completion: @escaping (_ result: RouterRequestResult) -> Void) {
		router.request(.mdataHistory) { (result) in
			completion(result)
        }
    }
}
