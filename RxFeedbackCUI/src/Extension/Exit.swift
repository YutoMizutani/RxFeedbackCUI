//
//  Exit.swift
//  RxFeedbackCUI
//
//  Created by YutoMizutani on 2018/01/25.
//  Copyright © 2018 Yuto Mizutani.
//  This software is released under the MIT License.
//

import Cocoa

//---- exit ------------------------------------------------------------------------------------------------------------------------------
extension NSViewController {
    public func exit() {
        NSApplication.shared.terminate(self)
    }
}
//-------------------------------------------------------------------------------------------------------------------------------------------------



