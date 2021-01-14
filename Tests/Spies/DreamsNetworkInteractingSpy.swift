//
//  File
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation
@testable import Dreams

final class DreamsNetworkInteractingSpy: DreamsNetworkInteracting {
    var didLoadCount: Int = 0
    var useWebViews: [WebViewProtocol] = []
    var useDelegates: [DreamsDelegate] = []
    var launchCredentials: [DreamsCredentials] = []
    var launchLocales: [Locale] = []
    var updateLocales: [Locale] = []
    
    func didLoad() {
        didLoadCount += 1
    }
    
    func use(webView: WebViewProtocol) {
        useWebViews.append(webView)
    }
    
    func use(delegate: DreamsDelegate) {
        useDelegates.append(delegate)
    }
    
    func launch(with credentials: DreamsCredentials, locale: Locale) {
        launchCredentials.append(credentials)
        launchLocales.append(locale)
    }
    
    func update(locale: Locale) {
        updateLocales.append(locale)
    }
    
    
}
