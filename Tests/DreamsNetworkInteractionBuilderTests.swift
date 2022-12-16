//
//  DreamsNetworkInteractionBuilderTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import XCTest
@testable import Dreams

class DreamsNetworkInteractionBuilderTests: XCTestCase {
    func testBuildWithConfiguration() {
        let configuration = DreamsConfiguration(clientId: "clientId", baseURL: URL(string: "https://dreamstech.com")!)
        
        let output = DreamsNetworkInteractionBuilder.build(configuration: configuration)
        
        XCTAssertTrue(output is DreamsNetworkInteraction)
    }
}
