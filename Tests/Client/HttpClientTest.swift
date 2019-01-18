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

import XCTest
@testable import apio_consumer_ios

class HttpClientTest: BaseTest {
    
    private let httpClient = HttpClient()
    
    private let serverUrl = "https://apiosample.wedeploy.io/"
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldReturnJsonWhenGetIsPerformed() {
        let expectation = XCTestExpectation(description: "Get resource through a serverUrl")
        
        guard let url = URL(string: serverUrl) else {
            XCTFail()
            return
        }

        httpClient.get(url: url) { result in
            switch result {
            case .success(let json):
                XCTAssertNotNil(json)
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testShouldReturnJsonWhenRequestIsPerformed() {
        
    }
}
