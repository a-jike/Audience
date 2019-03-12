//
//  AudienceView.swift
//  Audience
//
//  Created by Atsushi Jike on 2019/03/12.
//  Copyright © 2019 Atsushi Jike. All rights reserved.
//

import Cocoa
import SnapKit

class AudienceView: NSView {
    let itemSize = NSSize(width: 128, height: 96)
    var itemViews: [AudienceItemView] = []
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    override required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func addNew() {
        itemViews.append(AudienceItemView())
    }
}

class AudienceItemView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
