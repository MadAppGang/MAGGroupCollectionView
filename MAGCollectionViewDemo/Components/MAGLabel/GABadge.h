//
//  GABadge.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/6/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGLabel.h"

typedef NS_ENUM(NSUInteger , GABadgeState) {
    GABadgeStateUnknown,
    GABadgeStateSelected,
    GABadgeStateNormal,
    GABadgeStateGhost
};

@interface GABadge : MAGLabel

@property (nonatomic) GABadgeState state;
- (void)setFillColor:(UIColor *)fillColor strikeWidth:(NSNumber *)strokeWidth strokeColor:(UIColor*)strokeColor textColor:(UIColor *)textColor font:(UIFont *)font forState:(GABadgeState)state;

+ (UIFont *)defaultFont;
+ (UIEdgeInsets)defaultInsets;


@end
