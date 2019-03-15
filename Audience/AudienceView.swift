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
        collectionView.backgroundColors = [.clear]
        collectionView.collectionViewLayout = gridLayout
        collectionView.isSelectable = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"))
        wantsLayer = true
        layer?.borderColor = NSColor.red.cgColor
        layer?.borderWidth = 1
        collectionView.wantsLayer = true
        collectionView.layer?.borderColor = NSColor.green.cgColor
        collectionView.layer?.borderWidth = 2
        return collectionView
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        scrollView.drawsBackground = false
        scrollView.documentView = collectionView
        addSubview(scrollView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let itemsCount = items.count
        if itemsCount > 0,
            let superWidth = superview?.bounds.width,
            let gridLayout = collectionView.collectionViewLayout as? NSCollectionViewGridLayout {
            struct Matrix {
                var x: Int = 0
                var y: Int = 0
            }
            let itemSize = gridLayout.minimumItemSize
            let interitemSpacing = gridLayout.minimumInteritemSpacing
            let lineSpacing = gridLayout.minimumLineSpacing
            let margins = gridLayout.margins
            let size = NSSize(width: itemSize.width + interitemSpacing, height: itemSize.height + lineSpacing)
            var matrix: Matrix = Matrix(x: 0, y: 0)
            let horizontal = Int((superWidth - margins.left - margins.right) / size.width)
            matrix.x = min(itemsCount, horizontal)
            matrix.y = itemsCount > horizontal ? (itemsCount % horizontal > 0 ? (itemsCount / horizontal) + 1 : itemsCount / horizontal) : 1
            scrollView.snp.remakeConstraints { (make) in
                make.width.equalTo((size.width * CGFloat(matrix.x) + margins.left + margins.right))
                make.height.equalTo((size.height * CGFloat(matrix.y) + margins.top + margins.bottom))
            }
            snp.makeConstraints { (make) in
                make.top.centerX.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
            }
        }
    }

    func addNew() {
        let item = AudienceItem(title: String(items.count + 1))
        item.contentView = NSView()
        item.contentView?.wantsLayer = true
        item.contentView?.layer?.backgroundColor = NSColor.white.cgColor
        items.append(item)
        collectionView.reloadData()
        needsUpdateConstraints = true
    }
}

extension AudienceView: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let viewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as! CollectionViewItem
        let item = items[indexPath.item]
        viewItem.titleLabel.stringValue = item.title
        if viewItem.contentView != item.contentView {
           viewItem.contentView = item.contentView
        }
        return viewItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let firstIndexPath = indexPaths.first else { return }
        let item = items[firstIndexPath.item]
        
    }
}

final class CollectionViewItem: NSCollectionViewItem {
    let baseView = NSView()
    let titleLabel = NSTextField()
    var contentView: NSView? {
        didSet {
            if let contentView = contentView {
                baseView.addSubview(contentView, positioned: .below, relativeTo: titleLabel)
                contentView.snp.remakeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
    }

    override func loadView() {
        view = NSView()
        baseView.wantsLayer = true
        baseView.layer?.cornerRadius = 8
        baseView.layer?.backgroundColor = NSColor.gray.cgColor
        view.addSubview(baseView)

        titleLabel.textColor = .white
        titleLabel.isBordered = false
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.alignment = .center
        titleLabel.backgroundColor = NSColor(white: 0, alpha: 0.5)
        baseView.addSubview(titleLabel)

        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

final class AudienceItem: NSObject {
    let title: String
    var contentView: NSView?
    init(title: String) {
        self.title = title
        super.init()
    }
}
