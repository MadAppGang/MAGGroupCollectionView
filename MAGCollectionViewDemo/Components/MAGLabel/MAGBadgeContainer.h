//
//  MAGBadgeContainer.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/6/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGLabel.h"

@interface MAGBadgeContainer : MAGLabel

@property (nonatomic, assign) CGFloat elementMargin;
@property (nonatomic, strong) NSArray *elements;

+(CGSize)sizeForElements:(NSArray*)elements withElementMargins:(CGFloat)margins  containerInsets:(UIEdgeInsets)containerInsets;
+(CGSize)sizeForTextElements:(NSArray*)texts withFont:(UIFont*)font andInsets:(UIEdgeInsets)insets containerMargins:(CGFloat)margins containerInsets:(UIEdgeInsets)containerInsets;

+ (CGFloat)defaultElementMargin;
+ (UIEdgeInsets)defaultInsets;
@end
