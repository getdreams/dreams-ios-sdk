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

public protocol DreamsLaunching: class {
    /**
     This method MUST be called just after the DreamsViewController is presented, the Dreams interface will be launched for given credentials.
     - parameter credentials credentials: User credentials
     - parameter locale: Selected Locale
     */
    func launch(with credentials: DreamsCredentials, locale: Locale)
}

public protocol DreamsDelegateUsing: class {
    /**
     This method MUST be called before the ViewController is presented, otherwise delegate won't be able to mediate.
     - parameter delegate : DreamsDelegate handling events
     */
    func use(delegate: DreamsDelegate)
}

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
    
}

// MARK: DreamsLaunching
extension DreamsViewController: DreamsLaunching {

    /**
     This method MUST be called just after the DreamsViewController is presented, the Dreams interface will be launched for given credentials.
     - parameter credentials credentials: User credentials
     - parameter locale: Selected Locale
     */
    public func launch(with credentials: DreamsCredentials, locale: Locale) {
        interaction.launch(with: credentials, locale: locale)
    }
}

// MARK: DreamsDelegateUsing
extension DreamsViewController: DreamsDelegateUsing {

    /**
     This method MUST be called before the ViewController is presented, otherwise delegate won't be able to mediate.
     - parameter delegate : DreamsDelegate handling events
     */
    public func use(delegate: DreamsDelegate) {
        interaction.use(delegate: delegate)
    }
}
