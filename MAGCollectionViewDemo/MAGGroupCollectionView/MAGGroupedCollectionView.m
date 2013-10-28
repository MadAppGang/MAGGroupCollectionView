//
//  MAGGroupedCollectionView.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 27/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "MAGGroupedCollectionView.h"
#import "MAGCollectionViewGroupLayout.h"
#import "MAGGroupedCollectionViewDelegate.h"
#import "MAGGroupedCell.h"
static int kObservingCollectionViewLayoutContext;

#ifndef CGGEOMETRY__SUPPORT_H_
CG_INLINE CGPoint
_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, _ScrollingDirection) {
    _ScrollingDirectionUnknown = 0,
    _ScrollingDirectionUp,
    _ScrollingDirectionDown,
    _ScrollingDirectionLeft,
    _ScrollingDirectionRight
};

//@interface LSCollectionViewHelper ()
//{
//    NSIndexPath *lastIndexPath;
//    UIImageView *mockCell;
//    CGPoint mockCenter;
//    CGPoint fingerTranslation;
//    CADisplayLink *timer;
//    _ScrollingDirection scrollingDirection;
//    BOOL canWarp;
//    BOOL canScroll;
//}


@interface MAGGroupedCollectionView ()
@property (nonatomic,assign) _ScrollingDirection scrollingDirection;
@property (nonatomic, strong) UIView *mockCell;
@property (nonatomic) CGPoint mockCenter;
@property (nonatomic) CGPoint touchTranslation;
@property (nonatomic, strong) CADisplayLink *updateTimer;
@property (nonatomic) BOOL canDrag;
@property (nonatomic) BOOL canScroll;

@property (nonatomic, strong) UIGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIGestureRecognizer *panPressGestureRecognizer;

@property (nonatomic, strong) NSIndexPath *dragStartIndexPath;
@property (nonatomic, strong) NSIndexPath *dragDestinationIndexPath;

@end

@implementation MAGGroupedCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self CommonInitMAGGroupedCollectionView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self CommonInitMAGGroupedCollectionView];
    }
    return self;
}

-(void)CommonInitMAGGroupedCollectionView {
    _scrollingDirection = _ScrollingDirectionUnknown;
    [self addObserver:self
           forKeyPath:@"collectionViewLayout"
              options:0
              context:&kObservingCollectionViewLayoutContext];
    _scrollingEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
    _scrollingSpeed = 300.f;

    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:_longPressGestureRecognizer];

    _panPressGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                  initWithTarget:self action:@selector(handlePanGesture:)];
    _panPressGestureRecognizer.delegate = self;
    
    [self addGestureRecognizer:_panPressGestureRecognizer];
    
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
            break;
        }
    }
    
    [self layoutChanged];

}

- (void)layoutChanged {
    self.canDrag = [self.collectionViewLayout isKindOfClass:[MAGCollectionViewGroupLayout class]];
    self.canScroll = [self.collectionViewLayout respondsToSelector:@selector(scrollDirection)];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingCollectionViewLayoutContext) {
        [self layoutChanged];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)setDraggingEnabled:(BOOL)draggingEnabled {
    _draggingEnabled = draggingEnabled;
    self.longPressGestureRecognizer.enabled = self.isDraggingEnabled;
    self.panPressGestureRecognizer.enabled = self.isDraggingEnabled;
}

- (UIView *)snapshotViewFromCell:(UICollectionViewCell *)cell {
    return [cell snapshotViewAfterScreenUpdates:NO];
}

- (void)invalidatesScrollTimer {
    if (self.updateTimer != nil) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    self.scrollingDirection = _ScrollingDirectionUnknown;
}

- (void)setupScrollTimerInDirection:(_ScrollingDirection)direction {
    self.scrollingDirection = direction;
    if (self.updateTimer == nil) {
        self.updateTimer  = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
        [self.updateTimer  addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return self.dragStartIndexPath != nil;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:self.longPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:self.panPressGestureRecognizer];
    }
    
    if ([gestureRecognizer isEqual:self.panPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:self.longPressGestureRecognizer];
    }
    
    return NO;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) { return; }
//    if (![self.collectionView.dataSource conformsToProtocol:@protocol(UICollectionViewDataSource_Draggable)]) {
//        return;
//    }
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:[sender locationInView:self]];
    NSLog(@"index apath %@",indexPath);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath == nil) { return; }
            UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
            if (![(id<MAGGroupedCollectionViewDelegate>)self.dataSource  collectionView:self  canMoveItemAtIndexPath:indexPath] ||
                ![cell conformsToProtocol:@protocol(MAGGroupedCell)]) {
                return;
            }
            // Create mock cell to drag around
            cell.highlighted = NO;
            [self.mockCell removeFromSuperview];
            self.mockCell = [self snapshotViewFromCell:cell];
            self.mockCell.frame = cell.frame;
            self.mockCenter = self.mockCell.center;
            [self addSubview:self.mockCell];
            [UIView  animateWithDuration:0.3 animations:^{
                self.mockCell.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
            }
                              completion:nil];
            
            // Start warping
            [(id<MAGGroupedCell>)cell goingToDrag];
            self.dragStartIndexPath = indexPath;
            [self.collectionViewLayout invalidateLayout];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if(!self.dragStartIndexPath) {return;}
            UICollectionViewCell<MAGGroupedCell> *cell = (UICollectionViewCell<MAGGroupedCell>*)[self cellForItemAtIndexPath:self.dragDestinationIndexPath];
            CGPoint moveToPoint;
            void(^completition)();
            if (self.dragDestinationIndexPath) {
                CGRect rect = [cell frameForNewItem];
                moveToPoint = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
                [(id<MAGGroupedCollectionViewDelegate>)self.dataSource collectionView:self
                                                             didMoveItemFromIndexPath:self.dragStartIndexPath
                                                                          toIndexPath:self.dragDestinationIndexPath];

                // Move the item
                [self performBatchUpdates:^{
                    if (self.dragDestinationIndexPath) [self deleteItemsAtIndexPaths:@[self.dragStartIndexPath]];
                } completion:nil];
               NSIndexPath *ip = [self.dragDestinationIndexPath copy];
                completition = ^(){
                    [cell commitNewItemInsertion];
                    [self reloadItemsAtIndexPaths:@[ip]];
                    [self.collectionViewLayout invalidateLayout];
                };
            } else {
                // Tell the data source to move the item
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:self.dragStartIndexPath];
                moveToPoint = layoutAttributes.center;
                completition = ^(){
                    [cell cancelNewItemInsertion];
                };

            }
            
            [UIView  animateWithDuration:0.3
                              animations:^{
                                  self.mockCell.center = moveToPoint;
                                  self.mockCell.transform = CGAffineTransformMakeScale(1.f, 1.f);
                              }
                              completion:^(BOOL finished) {
                                  [self.mockCell removeFromSuperview];
                                  self.mockCell = nil;
                                  self.dragStartIndexPath= nil;
                                  self.dragDestinationIndexPath = nil;

                                  completition();
                                  [self.collectionViewLayout invalidateLayout];
//                                  [self reloadData];

                              }];

//            // Reset
            [self invalidatesScrollTimer];
        } break;
        default: break;
    }
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateChanged) {
        // Move mock to match finger
        self.touchTranslation = [sender translationInView:self];
        self.mockCell.center = _CGPointAdd(self.mockCenter, self.touchTranslation);
        
        // Scroll when necessary
        if (self.canScroll) {
            UICollectionViewFlowLayout *scrollLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
            if([scrollLayout scrollDirection] == UICollectionViewScrollDirectionVertical) {
                if (self.mockCell.center.y < (CGRectGetMinY(self.bounds) + self.scrollingEdgeInsets.top)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionUp];
                }
                else {
                    if (self.mockCell.center.y > (CGRectGetMaxY(self.bounds) - self.scrollingEdgeInsets.bottom)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionDown];
                    }
                    else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
            else {
                if (self.mockCell.center.x < (CGRectGetMinX(self.bounds) + self.scrollingEdgeInsets.left)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionLeft];
                } else {
                    if (self.mockCell.center.x > (CGRectGetMaxX(self.bounds) - self.scrollingEdgeInsets.right)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionRight];
                    } else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
        }
        
        // Avoid warping a second time while scrolling
        if (self.scrollingDirection > _ScrollingDirectionUnknown) {
            return;
        }
        
        // Insert item to finger location
        CGPoint point = [sender locationInView:self];
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
        if ([self.dragStartIndexPath compare:indexPath] != NSOrderedSame)  [self tryToInsertInPath:indexPath];
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)handleScroll:(NSTimer *)timer {
    if (self.scrollingDirection == _ScrollingDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.bounds.size;
    CGSize contentSize = self.contentSize;
    CGPoint contentOffset = self.contentOffset;
    CGFloat distance = self.scrollingSpeed / 60.f;
    CGPoint translation = CGPointZero;
    
    switch(self.scrollingDirection) {
        case _ScrollingDirectionUp: {
            distance = -distance;
            if ((contentOffset.y + distance) <= 0.f) {
                distance = -contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionLeft: {
            distance = -distance;
            if ((contentOffset.x + distance) <= 0.f) {
                distance = -contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        case _ScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width;
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        default: break;
    }
    
    self.mockCenter  = _CGPointAdd(self.mockCenter, translation);
    self.mockCell.center = _CGPointAdd(self.mockCenter, self.touchTranslation);
    self.contentOffset = _CGPointAdd(contentOffset, translation);
    
    // Insert items while scrolling
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:self.mockCell.center];
    if ([self.dragStartIndexPath compare:indexPath] != NSOrderedSame) [self tryToInsertInPath:indexPath];
}

-(void)tryToInsertInPath:(NSIndexPath*)indexPath {
    if(indexPath == nil || [self.dragDestinationIndexPath isEqual:indexPath]) {
        return;
    }
    
    if (self.dragDestinationIndexPath) {
        UICollectionViewCell<MAGGroupedCell> *cell = (UICollectionViewCell<MAGGroupedCell>*)[self cellForItemAtIndexPath:self.dragDestinationIndexPath];
        [cell cancelNewItemInsertion];
    }
    if ([self.dataSource respondsToSelector:@selector(collectionView:willMoveItemFromIndexPath:toIndexPath:)]
        && ![(id<MAGGroupedCollectionViewDelegate>)self.dataSource  collectionView:self
                                                                willMoveItemFromIndexPath:self.dragStartIndexPath
                                                                              toIndexPath:indexPath])
    {
        return;
    }

    UICollectionViewCell * cell = [self cellForItemAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(MAGGroupedCell)]) {
        UICollectionViewCell<MAGGroupedCell>* currentCell = (UICollectionViewCell<MAGGroupedCell>*)[self cellForItemAtIndexPath:self.dragStartIndexPath];
        [self insertSubview:cell belowSubview:self.mockCell];
        [(UICollectionViewCell<MAGGroupedCell>*)cell goingToInsertNewItem:currentCell];
        self.dragDestinationIndexPath = indexPath;
    }
    
}




@end
