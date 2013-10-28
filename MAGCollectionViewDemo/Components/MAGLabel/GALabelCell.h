//
//  GALabelCell.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 27/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGGroupedCell.h"
#import "GABadge.h"

@interface GALabelCell : UICollectionViewCell <MAGGroupedCell>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<MAGGroupedCell> ghostItem;
@property (nonatomic, assign) GABadgeState state;
- (CGRect)frameForNewItem;
- (void)commitNewItemInsertion;
- (void)goingToInsertNewItem:(id<MAGGroupedCell>)ghostItem;
- (void)cancelNewItemInsertion;
- (BOOL)isSingleItem;
- (void)goingToDrag;
- (void)dragFinished;

@end
