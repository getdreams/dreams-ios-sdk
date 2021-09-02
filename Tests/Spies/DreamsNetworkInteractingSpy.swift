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
    var navigateToLocations: [String] = []
    var useNavigations: [ViewControllerPresenting] = []
    var launchCredentials: [DreamsCredentials] = []
    var launchLocations: [String?] = []
    var completions: [((Result<Void, DreamsLaunchingError>) -> Void)] = []
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
    
    func launch(credentials: DreamsCredentials, locale: Locale, location: String?, completion: ((Result<Void, DreamsLaunchingError>) -> Void)?) {
        launchCredentials.append(credentials)
        launchLocales.append(locale)
        launchLocations.append(location)
        if let completion = completion {
            completions.append(completion)
        }
    }
    
    func update(locale: Locale) {
        updateLocales.append(locale)
    }

    func navigateTo(location: String) {
        navigateToLocations.append(location)
    }

    func use(navigation: ViewControllerPresenting) {
        useNavigations.append(navigation)
    }
}
