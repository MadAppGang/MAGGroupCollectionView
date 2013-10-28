//
//  MAGBadgeContainer.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/6/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "MAGBadgeContainer.h"
static CGFloat const kHorizontalInset = 6;
static CGFloat const kVerticalInset = 6;
static CGFloat const kDefaultElementMargin = 2;

static UIColor* colorWithRGBA(NSUInteger color)
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}

@implementation MAGBadgeContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    self.insets = UIEdgeInsetsMake(kVerticalInset, kHorizontalInset, kVerticalInset, kHorizontalInset);
    self.fillColor  = colorWithRGBA(0x578FFFFF);
    self.strokeColor = [UIColor clearColor];
    self.strokeWidth = 0;
    _elementMargin = kDefaultElementMargin;
    self.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = self.insets.left + self.insets.right;
    CGFloat height = self.insets.top + self.insets.bottom;
    CGFloat maxHeigth = 0;
    BOOL haveSubviews = NO;
    for (UIView *subView in self.elements) {
        CGSize subviewSize = [subView sizeThatFits:size];
        width += subviewSize.width + self.elementMargin;
        haveSubviews = YES;
        maxHeigth = subviewSize.height>maxHeigth?subviewSize.height:maxHeigth;
    }
    if (haveSubviews) width -= self.elementMargin;
    height += maxHeigth;
    return CGSizeMake(width, height);
}

- (void)layoutSubviews {
    CGFloat left = self.insets.left;
    for (UIView *subView in self.elements) {
        [subView sizeToFit];
        CGRect frame = subView.frame;
        frame.origin.x = left;
        frame.origin.y = self.insets.top;
        left += frame.size.width + self.elementMargin;
        subView.frame = frame;
    }
}

- (void)drawRect:(CGRect)rect {
    if (!self.superview) return;
    CGRect strokeRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.strokeWidth, self.strokeWidth, self.strokeWidth, self.strokeWidth));
    UIBezierPath* roundedRectangle4Path = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:INT32_MAX];
    [self.fillColor setFill];
    [roundedRectangle4Path fill];
    [self.strokeColor setStroke];
    roundedRectangle4Path.lineWidth = self.strokeWidth;
    [roundedRectangle4Path stroke];
}

- (void)setElements:(NSArray *)elements {
    if (elements == self.elements) return;
    for (UIView *v in self.elements) [v removeFromSuperview];
    _elements = elements;
    for (UIView *v in elements) {
       [self addSubview:v];
       [v setNeedsLayout];
       [v setNeedsDisplay];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setElementMargin:(CGFloat)elementMargin {
    if (self.elementMargin == elementMargin) return;
    _elementMargin = elementMargin;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}



-(CGSize)sizeForElements:(NSArray*)elements withElementMargins:(CGFloat)margins {
    CGFloat width = self.insets.left + self.insets.right;
    CGFloat height = self.insets.top + self.insets.bottom;
    CGFloat maxHeigth = 0;
    BOOL haveSubviews = NO;
    for (UIView *subView in self.subviews) {
        width += subView.frame.size.width + self.elementMargin;
        haveSubviews = YES;
        maxHeigth = subView.frame.size.height>maxHeigth?subView.frame.size.height:maxHeigth;
    }
    if (haveSubviews) width -= self.elementMargin;
    height += maxHeigth;
    return CGSizeMake(width, height);
}

+(CGSize)sizeForElements:(NSArray*)elements withElementMargins:(CGFloat)margins  containerInsets:(UIEdgeInsets)containerInsets {
    CGFloat width = containerInsets.left + containerInsets.right;
    CGFloat height = containerInsets.top + containerInsets.bottom;
    CGFloat maxHeigth = 0;
    for (UIView *element in elements) {
        CGSize elementSize = [element sizeThatFits:CGSizeZero];
        width += elementSize.width + margins;
        maxHeigth = elementSize.height>maxHeigth?elementSize.height:maxHeigth;
    }
    if ([elements count]>0) width -= margins;
    height += maxHeigth;
    return CGSizeMake(width, height);
}

+(CGSize)sizeForTextElements:(NSArray*)texts withFont:(UIFont*)font andInsets:(UIEdgeInsets)insets containerMargins:(CGFloat)margins containerInsets:(UIEdgeInsets)containerInsets {
    CGFloat width = containerInsets.left + containerInsets.right;
    CGFloat height = containerInsets.top + containerInsets.bottom;
    CGFloat maxHeigth = 0;
    for (NSString *text in texts) {
        CGSize elementSize = [MAGLabel sizeForText:text withFont:font andInsets:insets];
        width += elementSize.width + margins;
        maxHeigth = elementSize.height>maxHeigth?elementSize.height:maxHeigth;
    }
    if ([texts count]>0) width -= margins;
    height += maxHeigth;
    return CGSizeMake(width, height);
}

+(CGFloat)defaultElementMargin {
    return kDefaultElementMargin;
}

+ (UIEdgeInsets)defaultInsets {
    return UIEdgeInsetsMake(kVerticalInset, kHorizontalInset, kVerticalInset, kHorizontalInset);
}


@end
