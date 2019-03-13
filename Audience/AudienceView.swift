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
    var items: [AudienceItem] = []
    let scrollView = NSScrollView()
    lazy var collectionView: NSCollectionView = {
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumItemSize = NSSize(width: 100, height: 75)
        gridLayout.maximumItemSize = NSSize(width: 100, height: 75)
        gridLayout.minimumInteritemSpacing = 10
        gridLayout.minimumLineSpacing = 10
        gridLayout.margins = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = NSCollectionView()
        collectionView.collectionViewLayout = gridLayout
        collectionView.isSelectable = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"))
        return collectionView
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.borderColor = NSColor.red.cgColor
        layer?.borderWidth = 1
        scrollView.wantsLayer = true
        scrollView.layer?.borderColor = NSColor.yellow.cgColor
        scrollView.layer?.borderWidth = 2
        collectionView.wantsLayer = true
        collectionView.layer?.borderColor = NSColor.cyan.cgColor
        collectionView.layer?.borderWidth = 3
        
        scrollView.documentView = collectionView
        addSubview(scrollView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        scrollView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func addNew() {
        items.append(AudienceItem(title: String(items.count + 1)))
        collectionView.reloadData()
    }
}

extension AudienceView: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let viewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as! CollectionViewItem
        let item = items[indexPath.item]
        viewItem.textField?.stringValue = item.title
        return viewItem
    }
    
    
}

final class CollectionViewItem: NSCollectionViewItem {
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.borderColor = NSColor.green.cgColor
        view.layer?.borderWidth = 4
    }
}

final class AudienceItem: NSObject {
    let title: String
    init(title: String) {
        self.title = title
        super.init()
    }
}
