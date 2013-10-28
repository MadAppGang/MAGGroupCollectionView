//
//  GABadge.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/6/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "GABadge.h"
#import "UIColor+GAHEX.h"

static NSString * const kFillColorKey = @"fillColor";
static NSString * const kStrokeWidthKey = @"strokeWidth";
static NSString * const kStrokeColorKey = @"strokeColor";
static NSString * const kTextColorKey = @"textColor";
static NSString * const kFontKey = @"font";

static NSUInteger const kSelectedFillColor = 0x5ac8faff;
static NSUInteger const kUnselectedFillColor = 0xffffffff;

static CGFloat const kSelectedStrokeWidth = 0.;
static CGFloat const kUnselectedStrokeWidth = 2.;

static NSUInteger const kSelectedStrokeColor = 0x00000000;
static NSUInteger const kUnselectedStrokeColor = 0x5ac8faff;

static NSUInteger const kSelectedTextColor = 0x000000FF;
static NSUInteger const kUnselectedSTextColor = 0x000000FF;

@interface GABadge ()
@property (nonatomic, strong) NSMutableDictionary *stateValues;
@end

@implementation GABadge

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGABAdgeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGABAdgeInit];
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        [self commonGABAdgeInit];
    }
    return self;

}

- (void) commonGABAdgeInit {


    _stateValues = [NSMutableDictionary new];
    [self setFillColor:[UIColor colorWithRGBA:kUnselectedFillColor]
           strikeWidth:@(kUnselectedStrokeWidth)
           strokeColor:[UIColor colorWithRGBA:kUnselectedStrokeColor]
             textColor:[UIColor colorWithRGBA:kUnselectedSTextColor]
                  font:[UIFont systemFontOfSize:17.]
              forState:GABadgeStateNormal];

    [self setFillColor:[UIColor colorWithRGBA:kUnselectedFillColor]
           strikeWidth:@(kUnselectedStrokeWidth)
           strokeColor:[UIColor colorWithRGBA:kUnselectedStrokeColor]
             textColor:[UIColor colorWithRGBA:kUnselectedSTextColor]
                  font:[UIFont systemFontOfSize:17.]
              forState:GABadgeStateUnknown];

    [self setFillColor:[UIColor colorWithRGBA:kSelectedFillColor]
           strikeWidth:@(kSelectedStrokeWidth)
           strokeColor:[UIColor colorWithRGBA:kSelectedStrokeColor]
             textColor:[UIColor colorWithRGBA:kSelectedTextColor]
                  font:[UIFont systemFontOfSize:17.]
              forState:GABadgeStateSelected];

    [self setFillColor:[UIColor clearColor]
           strikeWidth:@(kUnselectedStrokeWidth)
           strokeColor:[UIColor lightGrayColor]
             textColor:[UIColor lightGrayColor]
                  font:[UIFont systemFontOfSize:17.]
              forState:GABadgeStateGhost];
    //to be sure
    _state = GABadgeStateUnknown;
    self.state = GABadgeStateNormal;

}

- (void)setState:(GABadgeState)state {
    if (state == _state) return;
    _state = state;
    self.fillColor = self.stateValues[@(self.state)][kFillColorKey];
    self.strokeWidth = [self.stateValues[@(self.state)][kStrokeWidthKey] floatValue];
    self.strokeColor = self.stateValues[@(self.state)][kStrokeColorKey];
    self.textColor = self.stateValues[@(self.state)][kTextColorKey];
    self.font = self.stateValues[@(self.state)][kFontKey];
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor strikeWidth:(NSNumber *)strokeWidth strokeColor:(UIColor *)strokeColor textColor:(UIColor *)textColor font:(UIFont *)font forState:(GABadgeState)state {
    [_stateValues setObject:@{kFillColorKey:fillColor,
            kStrokeWidthKey:strokeWidth,
            kStrokeColorKey:strokeColor,
            kTextColorKey:textColor,
            kFontKey:font
    }
                     forKey:@(state)];
}

+ (UIFont *)defaultFont {
    return [UIFont systemFontOfSize:17.];
}

+ (UIEdgeInsets)defaultInsets {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}


@end
