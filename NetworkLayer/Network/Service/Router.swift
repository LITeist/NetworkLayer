//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 22/07/2019.
//  Copyright © 2019 EPAM. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = (RouterRequestResult) -> Void

enum RouterRequestResult {
    case success(HTTPURLResponse, Data?)
    case failure(RouterError)
}

enum RouterError: Error {
    case requestSerializationError(Error)
    case authenticationError
    case serverError(code: Int, data: Data?)
    case requestFailed(Error)
    case unsupportedResponse
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .requestSerializationError: return "Could not create an URL request"
        case .authenticationError: return "You need to be authenticated first."
        case .serverError: return "Server Error"
        case .requestFailed: return "Network request failed."
        case .unsupportedResponse: return "We could not decode the response."
        case .unknownError: return "Unknown error"
        }
    }
}

private struct RouterConstants {
    static let timeOutInterval = 10.0
}

final class Router<EndPoint: EndPointType> {
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
		let session = URLSession(configuration: URLSession.shared.configuration, delegate: NSURLSessionPinningDelegate(), delegateQueue: nil)
        do {
            let request = try self.buildRequest(from: route)
            print("Sending \(request.url.debugDescription)")
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                let result = self.handleNetworkResponse(response, data: data)
                completion(result)
            })
            task.resume()
        } catch {
            completion(.failure(.requestSerializationError(error)))
        }
    }

    fileprivate func handleNetworkResponse(_ response: URLResponse?, data: Data?) -> RouterRequestResult {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unsupportedResponse)
        }
        switch httpResponse.statusCode {
        case 200...299:
            return .success(httpResponse, data)
        case 401...499:
            return .failure(.authenticationError)
        case 500...599:
            return .failure(.serverError(code: httpResponse.statusCode, data: data))
        default:
            return .failure(.unknownError)
        }
    }

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: RouterConstants.timeOutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        request.addHeaders(route.headers)

        switch route.task {
        case .requestPlain:
            request.addHeader(.contentTypeApplicationJson)
        case .requestJSONEncodable(let encodable):
            try request.addJSONBody(encodable)
            request.addHeader(.contentTypeApplicationJson)
        case .requestUrlParameters(let parameters):
            request.addUrlParameters(parameters)
            request.addHeader(.contentTypeUrlEncoded)
        case .requestCompositeParameters(let bodyEncodable, let urlParameters):
            request.addUrlParameters(urlParameters)
            try request.addJSONBody(bodyEncodable)
            request.addHeader(.contentTypeApplicationJson)
        }
        return request
    }
    
}
