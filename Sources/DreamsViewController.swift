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
     - parameter idToken: User idToken
     - parameter locale: Selected Locale
     */
    func launch(idToken: String, locale: Locale)
}

public protocol LocaleUpdating: class {
    /**
     This method can be called at all times after the DreamsViewController is presented, the Dreams interface will update to selected Locale.
     - parameter locale: Selected Locale
     */
    func update(locale: Locale)
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
        guard let configuration = Dreams.shared.configuration else {
            fatalError("Call Dreams.configure() in your AppDelegate")
        }
        self.interaction = DreamsNetworkInteractionBuilder.build(configuration: configuration)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder: NSCoder) {
        guard let configuration = Dreams.shared.configuration else {
            fatalError("Call Dreams.configure() in your AppDelegate")
        }
        self.interaction = DreamsNetworkInteractionBuilder.build(configuration: configuration)
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
     - parameter idToken: User idToken
     - parameter locale: Selected Locale
     */
    public func launch(idToken: String, locale: Locale) {
        interaction.launch(with: DreamsCredentials(idToken: idToken), locale: locale)
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

// MARK: LocaleUpdating
extension DreamsViewController: LocaleUpdating {

    /**
     This method can be called at all times after the DreamsViewController is presented, the Dreams interface will update to selected Locale.
     - parameter locale: Selected Locale
     */
    public func update(locale: Locale) {
        interaction.update(locale: locale)
    }
}
