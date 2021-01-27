//
//  FakeResponseMock
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

class FakeResponseMock: WKNavigationResponse {
   
   private let fakeResponse: URLResponse
   
   init(fakeResponse: URLResponse) {
       self.fakeResponse = fakeResponse
   }
   
   override var isForMainFrame: Bool {
       return true
   }

   override var response: URLResponse {
       return fakeResponse
   }

   override var canShowMIMEType: Bool {
       return true
   }
}
