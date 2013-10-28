//
//  MAGGroupedCell.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 27/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAGGroupedCell <NSObject>
- (CGRect)frameForNewItem;
- (void)commitNewItemInsertion;
- (void)goingToInsertNewItem:(id<MAGGroupedCell>)inseringItem;
- (void)cancelNewItemInsertion;
- (BOOL)isSingleItem;

- (void)goingToDrag;
- (void)dragFinished;
@end
