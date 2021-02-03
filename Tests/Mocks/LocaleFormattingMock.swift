//
//  LocaleFormattingMock
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation
@testable import Dreams

final class LocaleFormatterMock: LocaleFormatting {

    var returnString: String = ""

    var localesGiven: [Locale] = []
    var formatsGiven: [LocaleIdentifierFormat] = []

    func format(locale: Locale, format: LocaleIdentifierFormat) -> String {
        localesGiven.append(locale)
        formatsGiven.append(format)

        return returnString
    }
}
