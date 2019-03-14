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
    let audienceView = AudienceView(frame: .zero)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentView?.addSubview(audienceView)
        audienceView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    @IBAction func addNew(_ sender: Any) {
        audienceView.addNew()
    }

    @IBAction func moveToScreen(_ sender: Any) {
        window.isOpaque = false
        window.backgroundColor = .clear
    }

    @IBAction func backToWindow(_ sender: Any) {
        window.isOpaque = true
        window.backgroundColor = .darkGray
    }
}

