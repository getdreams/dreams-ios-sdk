//
//  LocaleFormatting
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

enum LocaleIdentifierFormat {
    case osDefault // Default format on iOS
    case bcp47 // ftp://ftp.isi.edu/in-notes/bcp/bcp47.txt
}

protocol LocaleFormatting {
    func format(locale: Locale, format: LocaleIdentifierFormat) -> String
}
