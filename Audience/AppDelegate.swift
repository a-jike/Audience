//
//  AppDelegate.swift
//  Audience
//
//  Created by Atsushi Jike on 2019/03/12.
//  Copyright © 2019 Atsushi Jike. All rights reserved.
//

import Cocoa
import SnapKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let audienceView = RollsView(frame: .zero)
    let subWindow = NSWindow(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: true)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(audienceView)
        audienceView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func addNew(_ sender: Any) {
        audienceView.addNew()
    }

    @IBAction func moveToScreen(_ sender: Any) {
        audienceView.removeFromSuperview()
        
        let windowRect = window.screen?.visibleFrame ?? .zero
        subWindow.setFrame(windowRect, display: true)
        subWindow.isOpaque = false
        subWindow.backgroundColor = .clear
        subWindow.contentView?.addSubview(audienceView)
        subWindow.orderFront(nil)
    }

    @IBAction func backToWindow(_ sender: Any) {
        audienceView.removeFromSuperview()
        window.contentView?.addSubview(audienceView)
        subWindow.orderOut(nil)
    }
}

