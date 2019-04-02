//
//  RollsView.swift
//  Audience
//
//  Created by Atsushi Jike on 2019/04/01.
//  Copyright © 2019 Atsushi Jike. All rights reserved.
//

import Cocoa

final class RollsView: NSView {
    let scrollView = NSScrollView()
    let stackView = NSStackView()
    let contentView = NSView()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        scrollView.drawsBackground = false
        scrollView.documentView = contentView
        addSubview(scrollView)
        
        stackView.orientation = .horizontal
        scrollView.documentView = stackView
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNew() {
        let view = NSView(frame: .zero)
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { (make) in
            make.size.equalTo(NSSize(width: 100, height: 75))
        }
    }
}
