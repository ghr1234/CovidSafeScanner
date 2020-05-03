//
//  AppDelegate.swift
//  CovidSafeScanner
//
//  Created by Paul Wilkinson on 28/4/20.
//  Copyright © 2020 Paul Wilkinson. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var bluetoothManager: BluetoothManager!
    var model: Model!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
              self.model = Model()
              
              self.bluetoothManager = BluetoothManager(model: self.model)
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(self.model)

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
      
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

