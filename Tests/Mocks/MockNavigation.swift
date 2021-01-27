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
import WebKit


final class MockNavigation: WKNavigation {
    @objc dynamic public func swizzledDeinit() {
        // nothing
    }
    
    //
    // Why? http://www.openradar.me/43934706
    //
    static func swizzleDeinitInWKNavigation() -> WKNavigation {
        let navigation = MockNavigation()
        let aClass: AnyClass! = object_getClass(navigation)
        let originalMethod = class_getInstanceMethod(aClass, NSSelectorFromString("dealloc"))
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(MockNavigation.swizzledDeinit))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        return navigation
    }
}
