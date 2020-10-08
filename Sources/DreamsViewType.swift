//
//  DreamsViewType
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation

public protocol DreamsViewType {

    /**
     Open the dreams view.
     - parameter accessToken: The accessToken.
     - parameter locale: The users locale.
     */
    func open(accessToken: String, locale: Locale)

    /**
     Update the accessToken.
     - parameter accessToken: The new accessToken.
     */
    func update(accessToken: String)

    /**
     Update the locale.
     - parameter locale: The new locale.
     */
    func update(locale: Locale)
}
