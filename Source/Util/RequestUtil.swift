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
class RequestUtil {
    static func buildURL(thingId: String, embedded: [String], fields: [String: [String]]) throws -> URL {
        var components = URLComponents(string: thingId)
        
        components?.queryItems = getQueryItems(embedded: embedded, fields: fields)
        
        guard let url = components?.url else {
            throw ApioError.thingNotFound
        }
        
        return url
    }
    
    static func mergeHeaders(defaultHeaders: RequestHeaders, headers: RequestHeaders) -> RequestHeaders {
        return defaultHeaders.merging(headers) { (_, new) in new }
    }
    
    private static func getQueryItems(embedded: [String], fields: [String: [String]]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if !embedded.isEmpty {
            queryItems.append(URLQueryItem(name: "embedded", value: embedded.joined(separator: ",")))
        }

        fields.forEach { field in
            let (key, value) = field
            
            queryItems.append(URLQueryItem(name: "field[\(key)]", value: value.joined(separator: ",")))
        }

        return queryItems
    }
}
