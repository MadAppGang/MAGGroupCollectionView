//
//  GALabelCell.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 27/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "GALabelCell.h"
#import "GABadge.h"
#import "GABadgeGroup.h"

@interface  GALabelCell ()
@property (nonatomic, strong) NSString *insertingItemText;
@property (nonatomic, strong) MAGLabel *badge;
@property (nonatomic, assign) GABadgeState realSate;
@end

@implementation GALabelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGALabelCellInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGALabelCellInit];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonGALabelCellInit];
    }
    return self;
}

- (void)commonGALabelCellInit {
    _state = GABadgeStateNormal;
}

- (CGRect)frameForNewItem {
    CGRect f = [((GABadgeGroup *)self.badge).elements.lastObject frame];
    CGRect result = [self.superview convertRect:f fromView:self];
    return result;
}

- (void)commitNewItemInsertion {
//    _items = [self.items arrayByAddingObject:self.insertingItemText];
//    NSLog(@"new Items %@",self.items);
    self.insertingItemText = nil;
    self.ghostItem = nil;
    [self resetLayout];
}

- (void)goingToInsertNewItem:(id <MAGGroupedCell>)ghostItem {
    if (!ghostItem.isSingleItem) return;
    if (ghostItem == self.ghostItem) return;
    GALabelCell *cell = (GALabelCell *) ghostItem;
    self.insertingItemText = cell.items[0];
    [self resetLayout];
    [self setNeedsLayout];
    [UIView animateWithDuration:0.4 animations:^{
        CGSize nfr = [self.badge sizeThatFits:CGSizeZero];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, nfr.width, nfr.height);
//        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void)resetLayout {
    [self.badge removeFromSuperview];
    self.badge = nil;
    [self removeConstraints:self.constraints];
    if ([self.items count]>1 || self.insertingItemText) {
        self.badge = [GABadgeGroup new];
        [(GABadgeGroup *)self.badge setSelected:YES];
        NSMutableArray *elements = [NSMutableArray new];
        for (NSString *text in self.items) {
            GABadge * badge = [GABadge new];
            badge.state = GABadgeStateSelected;
            badge.text  = text;
            [elements addObject:badge];
        }
        if (self.insertingItemText) {
            GABadge * badge = [GABadge new];
            badge.state = GABadgeStateGhost;
            badge.text  = self.insertingItemText;
            [elements addObject:badge];
        }
        [(GABadgeGroup *)self.badge setElements:elements];
    }  else {
        GABadge * badge = [GABadge new];
        badge.state = self.state;
        badge.text  = self.items[0];
        self.badge = badge;
    }
    [self addSubview:self.badge];
    self.badge.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.badge sizeToFit];
    [self.badge layoutSubviews];
}

- (void)cancelNewItemInsertion {
    self.insertingItemText =  nil;
    [self resetLayout];
    [self setNeedsUpdateConstraints];
    self.ghostItem = nil;
    [UIView animateWithDuration:0.4 animations:^{
        CGSize nfr = [self.badge sizeThatFits:CGSizeZero];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, nfr.width, nfr.height);
//        self.transform = CGAffineTransformIdentity;
    }];
}

- (BOOL)isSingleItem {
    return ([self.items count] == 1);
}

- (void)goingToDrag {
    //can drag only single items
    self.realSate = ((GABadge *)self.badge).state;
    ((GABadge *)self.badge).state = GABadgeStateGhost;
}

- (void)dragFinished {
    ((GABadge *)self.badge).state = self.realSate;
}

- (void)setItems:(NSArray *)items {
    NSLog(@"got new Items:%@",items);
    _items = items;
    [self resetLayout];
    [self setNeedsDisplay];
}

- (void)setState:(GABadgeState)state {
    _state = state;
    [self resetLayout];
}

@end
