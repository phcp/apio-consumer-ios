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
class ApioConsumer {
    
    var defaultHeaders: RequestHeaders
    private let httpClient = HttpClient()
    
    init(defaultHeaders: RequestHeaders = [:]) {
        self.defaultHeaders = defaultHeaders
    }
    
    func fetchResource(thingId: String, config: RequestConfiguration = RequestConfiguration(),
                       then handler: @escaping (Result<Thing>) -> Void) {
        
        do {
            let url = try RequestUtil.buildURL(thingId: thingId, embedded: config.embedded, fields: config.fields)
            let headers = RequestUtil.mergeHeaders(defaultHeaders: defaultHeaders, headers: config.headers)

            httpClient.get(url: url, headers: headers) { result in
                switch result {
                case .success(let json):
                    let (thing, _) = JsonLDParser.parseThing(json: json)
                    handler(Result.success(thing))
                case .failure(let error):
                    handler(Result.failure(error))
                }
            }
        }
        catch {
            handler(Result.failure(error))
        }
    }
    
    func getOperationForm(operationExpects: String, config: RequestConfiguration = RequestConfiguration(),
                          then handler: @escaping (Result<[Property]>) -> Void) {
        
        fetchResource(thingId: operationExpects, config: config) { result in
            
        }
    }
    
    func performOperation(thingId: String, operationId: String,
                          config: RequestConfiguration = RequestConfiguration(),
                          fillFields: ([Property]) -> [String: Any],
                          then handler: @escaping (Result<Thing>) -> Void) {
        
        do {
            let url = try thingId.asURL()
            let headers = RequestUtil.mergeHeaders(defaultHeaders: defaultHeaders, headers: config.headers)
            let method = "POST" // TODO Get operation model from cache
            
            httpClient.request(url: url, method: method, headers: headers) { result in
                switch result {
                case .success(let json):
                    let (thing, _) = JsonLDParser.parseThing(json: json)
                    handler(Result.success(thing))
                case .failure(let error):
                    handler(Result.failure(error))
                }
            }
        }
        catch {
            handler(Result.failure(error))
        }
    }
    
    func onRequestCompleted(result: Result<[String: Any?]>, completion: @escaping (Result<Thing>) -> Void) {
        switch result {
        case .success(let json):
            let (thing, _) = JsonLDParser.parseThing(json: json)
            completion(Result.success(thing))
        case .failure(let error):
            completion(Result.failure(error))
        }
    }
}
