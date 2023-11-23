//
//  MosaicLayout.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 14.06.2023.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForImageAtIndexPath indexPath: IndexPath) -> CGFloat?
}

final class CustomCollectionViewLayout:UICollectionViewLayout {
    
    //MARK: - Constants
    private struct Constants {
        static let numberOfColumns: Int = 2
        static let cellPadding: CGFloat = 2
    }
    
    weak var delegate: CustomCollectionViewLayoutDelegate?
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        
        let columnWidth = contentWidth / CGFloat(Constants.numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<Constants.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: Constants.numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let imageSize = delegate?.collectionView(collectionView, sizeForImageAtIndexPath: indexPath) ?? 180
            let height = (Constants.cellPadding * 2) + (columnWidth * imageSize)
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            
            let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (Constants.numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
