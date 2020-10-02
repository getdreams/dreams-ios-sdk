//
//  DreamsTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
@testable import Dreams

class DreamsTests: XCTestCase {

    override class func tearDown() {
        Dreams.shared.reset()
        super.tearDown()
    }

    func testSetup() {
        XCTAssertFalse(Dreams.shared.initialized)
        Dreams.setup(clientId: "clientId", baseURL: "https://getdreams.com")
        XCTAssertTrue(Dreams.shared.clientId == "clientId")
        XCTAssertTrue(Dreams.shared.baseURL == URL(string: "https://getdreams.com"))
        XCTAssertTrue(Dreams.shared.initialized)
    }

    func testInvalidSetup1() {
        XCTAssertFalse(Dreams.shared.initialized)
        Dreams.setup(clientId: "", baseURL: "https://getdreams.com")
        XCTAssertNil(Dreams.shared.clientId)
        XCTAssertNil(Dreams.shared.baseURL)
        XCTAssertFalse(Dreams.shared.initialized)
    }

    func testInvalidSetup2() {
        XCTAssertFalse(Dreams.shared.initialized)
        Dreams.setup(clientId: "clientId", baseURL: "")
        XCTAssertNil(Dreams.shared.clientId)
        XCTAssertNil(Dreams.shared.baseURL)
        XCTAssertFalse(Dreams.shared.initialized)
    }
}
