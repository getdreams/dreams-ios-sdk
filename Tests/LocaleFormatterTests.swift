//
//  LocaleFormatterTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import XCTest
import WebKit
@testable import Dreams

final class LocaleFormatterTests: XCTestCase {

    private var subject: LocaleFormatter!

    override func setUpWithError() throws {
        subject = LocaleFormatter()
    }

    func test_format_bcp47_only_language() {
        let locale = Locale(identifier: "sv")
        let formatted = subject.format(locale: locale, format: .bcp47)

        XCTAssertEqual(formatted, "sv")
    }

    func test_format_bcp47_languageAndRegion() {
        let locale = Locale(identifier: "sv_SE")
        let formatted = subject.format(locale: locale, format: .bcp47)

        XCTAssertEqual(formatted, "sv-SE")
    }

    func test_format_osDefault_only_language() {
        let locale = Locale(identifier: "sv")
        let formatted = subject.format(locale: locale, format: .osDefault)

        XCTAssertEqual(formatted, "sv")
    }

    func test_format_osDefault_underscore_languageAndRegion() {
        let locale = Locale(identifier: "sv_SE")
        let formatted = subject.format(locale: locale, format: .osDefault)

        XCTAssertEqual(formatted, "sv_SE")
    }

    func test_format_osDefault_dash_languageAndRegion() {
        let locale = Locale(identifier: "sv-SE")
        let formatted = subject.format(locale: locale, format: .osDefault)

        XCTAssertEqual(formatted, "sv-SE")
    }
}
