//
//  LocaleFormatter
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

final class LocaleFormatter: LocaleFormatting {

    private enum Constants {
        static let hyphen: String = "-"
    }

    func format(locale: Locale, format: LocaleIdentifierFormat) -> String {
        switch format {
        case .bcp47:
            return formatToBCP47(locale: locale)
        case .osDefault:
            return locale.identifier
        }
    }

    private func formatToBCP47(locale: Locale) -> String {
        let components = [locale.languageCode, locale.regionCode]
        return components.compactMap({ $0 }).joined(separator: Constants.hyphen)
    }
}
