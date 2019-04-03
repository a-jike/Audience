//
//  RollsView.swift
//  Audience
//
//  Created by Atsushi Jike on 2019/04/01.
//  Copyright © 2019 Atsushi Jike. All rights reserved.
//

import Cocoa

final class RollsView: NSView {
    let scrollView = ScrollView()
    let contentView = NSView()
    private let maximumColumn: Int = 5
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.borderColor = NSColor.red.cgColor
        layer?.borderWidth = 1

        scrollView.drawsBackground = false
        scrollView.wantsLayer = true
        scrollView.layer?.borderColor = NSColor.orange.cgColor
        scrollView.layer?.borderWidth = 2
        scrollView.documentView = contentView
        addSubview(scrollView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard contentView.subviews.count > 0 else { return }
        
        let itemsCount = contentView.subviews.count
        let itemSize = NSSize(width: 100, height: 75)
        let spacing: CGFloat = 4
        let buttonInset = NSEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        let scrollSize = NSSize(width: itemSize.width * CGFloat(min(maximumColumn, itemsCount)) + spacing * CGFloat(min(maximumColumn, itemsCount) - 1),
                                 height: itemSize.height)
        let viewSize = itemsCount <= maximumColumn ? scrollSize : NSSize(width: scrollSize.width + buttonInset.left + buttonInset.right, height: scrollSize.height)
        let contentSize = NSSize(width: itemSize.width * CGFloat(itemsCount) + spacing * CGFloat(itemsCount - 1),
                                 height: itemSize.height)
        let scrollLeading = contentSize.width > scrollSize.width ? buttonInset.left : 0
        snp.remakeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.size.equalTo(viewSize)
        }
        contentView.snp.remakeConstraints { (make) in
            make.size.equalTo(contentSize)
        }
        scrollView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().inset(scrollLeading)
            make.size.equalTo(scrollSize)
        }
        contentView.subviews.enumerated().forEach { (index, subview) in
            let leading = CGFloat(index) * (itemSize.width + spacing)
            subview.snp.remakeConstraints({ (make) in
                make.leading.equalTo(leading)
                make.top.equalToSuperview()
                make.size.equalTo(itemSize)
            })
        }
    }
    
    func addNew() {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 75))
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.green.cgColor
        view.layer?.borderWidth = 3
        contentView.addSubview(view)
        needsUpdateConstraints = true
    }
    
    final class ScrollView: NSScrollView {
        override func scrollWheel(with event: NSEvent) {
            // Do nothing
        }
    }
}
