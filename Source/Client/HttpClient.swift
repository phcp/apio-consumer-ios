/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

import Foundation

/**
 * @author Paulo Cruz
 */
class HttpClient {
    
    func get(url: URL, headers: [String: String] = [:], completion: @escaping (Result<[String: Any?]>) -> Void) {
        request(url: url, method: "GET", headers: headers, completion: completion)
    }
    
    func request(url: URL, method: String, headers: [String: String], body: String? = nil,
                 completion: @escaping (Result<[String: Any?]>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body?.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let responseData = data,
                   let json = try responseData.asJsonObject() {
                    completion(Result.success(json))
                }
                else if let responseError = error {
                    throw responseError
                }
                else {
                    throw ApioError.thingNotFound
                }
            }
            catch {
                completion(Result.failure(error))
            }
        }.resume()
    }
}


