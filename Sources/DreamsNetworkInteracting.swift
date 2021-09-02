//
//  DreamsNetworkInteracting
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

// MARK: DreamsNetworkInteracting

public protocol DreamsNetworkInteracting {
    func didLoad()
    func use(webView: WebViewProtocol)
    func use(navigation: ViewControllerPresenting)
    func use(delegate: DreamsDelegate)
    func launch(credentials: DreamsCredentials, locale: Locale, location: String?, completion: ((Result<Void, DreamsLaunchingError>) -> Void)?)
    func update(locale: Locale)
    func navigateTo(location: String)
}

extension DreamsNetworkInteracting {
    func launch(credentials: DreamsCredentials, locale: Locale) {
        launch(credentials: credentials, locale: locale, location: nil, completion: nil)
    }
}
