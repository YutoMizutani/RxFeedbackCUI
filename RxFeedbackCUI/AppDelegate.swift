//
//  AppDelegate.swift
//  RxFeedbackCUI
//
//  Created by YutoMizutani on 2018/01/31.
//  Copyright © 2018 Yuto Mizutani.
//  This software is released under the MIT License.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        // Hide the window when did launch
        NSApplication.shared.windows.last!.close()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

