//
//  WebServiceTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
import WebKit
@testable import Dreams

class WebServiceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Dreams.configure(DreamsConfiguration(clientId: "clientId", baseURL: URL(string: "https://www.dreamstech.com")!))
    }

    func testLoadURL1() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let mockURL = URL(string: "https://dreamstech.com")!
        
        service.load(url: mockURL, method: "POST", body: ["test": "test"]) { result in
            // Nothing
        }

        let event = spyDelegate.events.last
        let request = event?["request"] as! URLRequest

        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.url, mockURL)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, try! JSONSerialization.data(withJSONObject: ["test": "test"]))
    }

    func testLoadURL2() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let mockURL = URL(string: "https://dreamstech.com")!
        service.load(url: mockURL, method: "GET") { result in
            // Nothing
        }

        let event = spyDelegate.events.last
        let request = event?["request"] as! URLRequest

        XCTAssertEqual(request.url, mockURL)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
    }

    func testPrepareRequesteMessage() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let jsonObject: JSONObject = ["idToken": "someIdToken"]
        service.prepareRequestMessage(event: .updateIdToken, with: jsonObject)

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedMessage = "updateIdToken('{\"idToken\":\"someIdToken\"}')"

        XCTAssertEqual(message, expectedMessage)
    }

    func testHandleResponseMessage() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        service.handleResponseMessage(name: "onIdTokenDidExpire", body: nil)

        let event = spyDelegate.events.last
        let eventResponseType = event?["event"] as! ResponseEvent
        
        XCTAssertEqual(eventResponseType, .onIdTokenDidExpire)
    }
    
    func test_loadURL_got_200_success() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        let mockURL = URL(string: "https://dreamstech.com")!
        let webView = WKWebView()
        let urlResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let navigationResponse = FakeResponseMock(fakeResponse: urlResponse!)
        
        var resultGiven: Result<Void, DreamsLaunchingError>? = nil
        service.load(url: mockURL, method: "POST", body: ["test": "test"]) { result in
            resultGiven = result
        }
      
        service.webView(webView, decidePolicyFor: navigationResponse) { policy in
            // Ignored
        }
        
        guard case .success = resultGiven else {
            XCTFail()
            return
        }
    }
    
    func test_loadURL_got_422_invalidCredentials() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        let mockURL = URL(string: "https://dreamstech.com")!
        let webView = WKWebView()
        let urlResponse = HTTPURLResponse(url: mockURL, statusCode: 422, httpVersion: nil, headerFields: nil)
        let navigationResponse = FakeResponseMock(fakeResponse: urlResponse!)
        
        var resultGiven: Result<Void, DreamsLaunchingError>? = nil
        service.load(url: mockURL, method: "POST", body: ["test": "test"]) { result in
            resultGiven = result
        }
      
        service.webView(webView, decidePolicyFor: navigationResponse) { policy in
            // Ignored
        }
        
        if case let .failure(reason) = resultGiven {
            XCTAssertEqual(reason, DreamsLaunchingError.invalidCredentials)
        } else {
            XCTFail()
        }
    }
    
    func test_loadURL_got_500_httpErrorStatus() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        let mockURL = URL(string: "https://dreamstech.com")!
        let webView = WKWebView()
        let status = 500
        let urlResponse = HTTPURLResponse(url: mockURL, statusCode: status, httpVersion: nil, headerFields: nil)
        let navigationResponse = FakeResponseMock(fakeResponse: urlResponse!)
        
        var resultGiven: Result<Void, DreamsLaunchingError>? = nil
        service.load(url: mockURL, method: "POST", body: ["test": "test"]) { result in
            resultGiven = result
        }
      
        service.webView(webView, decidePolicyFor: navigationResponse) { policy in
            // Ignored
        }
        
        if case let .failure(reason) = resultGiven {
            if case let .httpErrorStatus(status) = reason {
                XCTAssertEqual(status, status)
            } else {
                XCTFail()
            }
           
        } else {
            XCTFail()
        }
    }
    
    func test_loadURL_failedNavigation_requestFailure() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        let mockURL = URL(string: "https://dreamstech.com")!
        let webView = WKWebView()
        let error = NSError(domain: "BLABLA", code: 0, userInfo: nil)
        let navigation = MockNavigation.swizzleDeinitInWKNavigation()
        
        var resultGiven: Result<Void, DreamsLaunchingError>? = nil
        service.load(url: mockURL, method: "POST", body: ["test": "test"]) { result in
            resultGiven = result
        }
      
        service.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
        
        if case let .failure(reason) = resultGiven {
            if case let .requestFailure(failureError) = reason {
                XCTAssertEqual(error.code, failureError.code)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
}

