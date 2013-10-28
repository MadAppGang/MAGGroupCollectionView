//
// Created by Ievgen Rudenko on 10/20/13.
// Copyright (c) 2013 MadAppGang. All rights reserved.
//


#import "GABadgeGroup.h"
#import "UIColor+GAHEX.h"


static NSUInteger const kSelectedFillColor = 0x007affFF;
static NSUInteger const kUnselectedFillColor = 0x000000ff;

static CGFloat const kSelectedStrokeWidth = 0.;
static CGFloat const kUnselectedStrokeWidth = 2.;

static NSUInteger const kSelectedStrokeColor = 0x00000000;
static NSUInteger const kUnselectedStrokeColor = 0x5856d6FF;

static NSUInteger const kSelectedTextColor = 0x000000FF;
static NSUInteger const kUnselectedSTextColor = 0x000000FF;

@implementation GABadgeGroup {

}



-(void)setSelected:(BOOL)selected {
    if (selected == self.selected) return;
    _selected = selected;
    self.fillColor = self.selected?[UIColor colorWithRGBA:kSelectedFillColor]:[UIColor colorWithRGBA:kUnselectedFillColor];
    self.strokeWidth = self.selected?kSelectedStrokeWidth:kUnselectedStrokeWidth;
    self.strokeColor = self.selected?[UIColor colorWithRGBA:kSelectedStrokeColor]:[UIColor colorWithRGBA:kUnselectedStrokeColor];
    self.textColor = self.selected?[UIColor colorWithRGBA:kSelectedTextColor]:[UIColor colorWithRGBA:kUnselectedSTextColor];
    [self setNeedsDisplay];

}
@end