//
//  DreamsViewControllerTests
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

class DreamsViewControllerTests: XCTestCase {
    
    private var interaction: DreamsNetworkInteractingSpy!
    private var subject: DreamsViewController!

    override func setUp() {
        super.setUp()

        interaction = DreamsNetworkInteractingSpy()
    }
    
    func testFromInit() {
        Dreams.configure(clientId: "clientId", baseURL: URL(string: "https://getdreams.com")!)
        subject = DreamsViewController()
    }
    
    func testFromNib() {
        Dreams.configure(clientId: "clientId", baseURL: URL(string: "https://getdreams.com")!)
        subject = DreamsViewController(nibName: nil, bundle: nil)
    }
    
    func testLoadView() {
        subject = DreamsViewController(interaction: interaction)
        let delegate = DreamsDelegateSpy()
        subject.use(delegate: delegate)
        
        let view = subject.view
        
        XCTAssertEqual(interaction.useWebViews.count, 1)
        XCTAssertTrue(interaction.useWebViews.first === view)
    }
    
    func testUseDelegate() {
        subject = DreamsViewController(interaction: interaction)
        let delegate = DreamsDelegateSpy()
        subject.use(delegate: delegate)
        
        XCTAssertEqual(interaction.useDelegates.count, 1)
        XCTAssertTrue(interaction.useDelegates.first === delegate)
    }

    func testLaunch() {
        subject = DreamsViewController(interaction: interaction)
        let idToken = "aaa"
        let credentials = DreamsCredentials(idToken: idToken)
        let locale = Locale(identifier: "sv_SE")
        
        subject.launch(idToken: idToken, locale: locale)
        
        XCTAssertEqual(interaction.launchCredentials.count, 1)
        XCTAssertEqual(interaction.launchCredentials.first!.idToken, credentials.idToken)
        XCTAssertEqual(interaction.launchLocales.count, 1)
        XCTAssertEqual(interaction.launchLocales.first!, locale)
    }

    func testUpdateLocale() {
        subject = DreamsViewController(interaction: interaction)
        let locale = Locale(identifier: "sv_SE")

        subject.update(locale: locale)
        
        XCTAssertEqual(interaction.updateLocales.count, 1)
        XCTAssertEqual(interaction.updateLocales.first!, locale)
    }

}
