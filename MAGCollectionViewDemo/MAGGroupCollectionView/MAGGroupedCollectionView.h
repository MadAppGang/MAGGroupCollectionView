//
//  MAGGroupedCollectionView.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 27/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAGGroupedCollectionView : UICollectionView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, assign, getter = isDraggingEnabled) BOOL draggingEnabled;

@end
