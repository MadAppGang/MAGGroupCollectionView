//
//  MAGCollectionViewLeftAllignedFlowLayout.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 26/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "MAGCollectionViewLeftAllignedFlowLayout.h"

const NSInteger kMaxCellSpacing = 9;

@implementation MAGCollectionViewLeftAllignedFlowLayout

-(instancetype)init {
    self = [super init];
    if (self) {
        _leftAlligned = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _leftAlligned = YES;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    if (self.isLeftAlligned) {
        for (UICollectionViewLayoutAttributes* attributes in layoutAttributes) {
            if (!attributes.representedElementKind) {
                NSIndexPath* indexPath = attributes.indexPath;
                attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            }
        }
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (!self.isLeftAlligned) return currentItemAttributes;
    
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    
    if (indexPath.item == 0) { // first item of section
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + self.minimumInteritemSpacing;
    
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentFrame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) { // if current item is the first item on the line
        // the approach here is to take the current frame, left align it to the edge of the view
        // then stretch it the width of the collection view, if it intersects with the previous frame then that means it
        // is on the same line, otherwise it is on it's own new line
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = frame.origin.x = sectionInset.left; // first item on the line should always be left aligned
        currentItemAttributes.frame = frame;
    } else {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = previousFrameRightPoint;
        currentItemAttributes.frame = frame;
    }
    return currentItemAttributes;
}

-(void)setLeftAlligned:(BOOL)leftAlligned {
    if (leftAlligned==self.isLeftAlligned) return;
    _leftAlligned = leftAlligned;
    [self invalidateLayout];
}



@end
