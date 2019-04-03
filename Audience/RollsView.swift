//
//  RollsView.swift
//  Audience
//
//  Created by Atsushi Jike on 2019/04/01.
//  Copyright © 2019 Atsushi Jike. All rights reserved.
//

import Cocoa

final class RollsView: NSView {
    enum Direction {
        case backword
        case forward
    }
    let scrollView = ScrollView()
    let contentView = NSView()
    let previousButton = NSButton()
    let nextButton = NSButton()
    private let maximumColumn: Int = 5
    private let spacing: CGFloat = 4
    private let itemSize = NSSize(width: 100, height: 75)
    private let buttonInset = NSEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
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
        
        previousButton.wantsLayer = true
        previousButton.layer?.borderColor = NSColor.yellow.cgColor
        previousButton.layer?.borderWidth = 2
        previousButton.isBordered = false
        previousButton.setButtonType(.momentaryPushIn)
        previousButton.keyEquivalent = "\r"   // Assign Return key
        previousButton.target = self
        previousButton.action = #selector(RollsView.previousButtonPushed(sender:))
        previousButton.isHidden = true
        addSubview(previousButton)
        
        nextButton.wantsLayer = true
        nextButton.layer?.borderColor = NSColor.yellow.cgColor
        nextButton.layer?.borderWidth = 2
        nextButton.isBordered = false
        nextButton.setButtonType(.momentaryPushIn)
        nextButton.keyEquivalent = "\r"   // Assign Return key
        nextButton.target = self
        nextButton.action = #selector(RollsView.nextButtonPushed(sender:))
        nextButton.isHidden = true
        addSubview(nextButton)
        
        previousButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(buttonInset.left)
        }
        nextButton.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(buttonInset.right)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard contentView.subviews.count > 0 else { return }
        
        let itemsCount = contentView.subviews.count
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
        let view = NSView(frame: NSRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height))
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.green.cgColor
        view.layer?.borderWidth = 3
        contentView.addSubview(view)
        
        previousButton.isHidden = contentView.subviews.count <= maximumColumn
        nextButton.isHidden = contentView.subviews.count <= maximumColumn
        needsUpdateConstraints = true
    }
    
    @objc private func previousButtonPushed(sender: NSButton) {
        scroll(to: .backword)
    }
    
    @objc private func nextButtonPushed(sender: NSButton) {
        scroll(to: .forward)
    }
    
    private func scroll(to direction: Direction) {
        let contentView = scrollView.contentView
        var point = contentView.bounds.origin
        switch direction {
        case .backword:
            point.x = max(0, point.x - (itemSize.width + spacing))
        case .forward:
            point.x += (itemSize.width + spacing)
        }
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        contentView.animator().setBoundsOrigin(point)
        scrollView.reflectScrolledClipView(contentView)
        NSAnimationContext.endGrouping()
    }
    
    final class ScrollView: NSScrollView {
        override func scrollWheel(with event: NSEvent) {
            // Do nothing
        }
    }
}
