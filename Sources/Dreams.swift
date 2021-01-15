//
//  Dreams
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation

public final class Dreams {
    
    /**
      Must be set before using the Dreams iOS SDK

     # Notes: #
     Set this up in your AppDelegate `application(_:didFinishLaunchingWithOptions:)` .
     */
    private(set) var configuration: DreamsConfiguration?
    
    /**
     The shared singleton instance.
     */
    public static var shared = Dreams()

    /**
     This method must be called before using the Dreams iOS SDK
     - parameter _ configuration: Configuration for  Dreams iOS SDK

     # Notes: #
     Call this function in your AppDelegates `application(_:didFinishLaunchingWithOptions:)` .
     */
    public static func configure(_ configuration: DreamsConfiguration) {
        shared.configuration = configuration
    }

    internal init() {}
}
