//
//  DreamsViewController
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import UIKit
import WebKit

public class DreamsViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let interaction: DreamsNetworkInteracting
    
    public init(interaction: DreamsNetworkInteracting) {
        self.interaction = interaction
        super.init(nibName: nil, bundle: nil)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.interaction = DreamsNetworkInteractionBuilder.build()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder: NSCoder) {
        self.interaction = DreamsNetworkInteractionBuilder.build()
        super.init(coder: coder)
    }

    public override func loadView() {
        view = webView
        interaction.use(webView: webView)
    }
    
    public override func viewDidLoad() {
        interaction.didLoad()
    }
    
    // MARK: START
    
    /**
     This method should be called just after the ViewController is presented for the Dreams interface be launched for given credentials.
     - parameter credentials credentials: User credentials
     - parameter locale: Selected Locale
     */
    public func open(credentials: DreamsCredentials, locale: Locale) {
        interaction.start(with: credentials, locale: locale)
    }
}
