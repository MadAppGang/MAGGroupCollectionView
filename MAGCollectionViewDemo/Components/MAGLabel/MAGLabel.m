//
//  GALabel.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/1/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "MAGLabel.h"
#import "UIColor+GAHEX.h"

static CGFloat const kHorizontalInset = 10;
static CGFloat const kVerticalInset = 5;



@implementation MAGLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonMAGLabelInit];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonMAGLabelInit];
    }
    return self;
}

-(void)commonMAGLabelInit {
    _insets = UIEdgeInsetsMake(kVerticalInset, kHorizontalInset, kVerticalInset, kHorizontalInset);
    _fillColor  = [UIColor colorWithRGBA:0x57C7FFFF];
    _strokeColor = [UIColor colorWithRGBA:0x57C7FFFF];
    _textColor = [UIColor blackColor];
    _strokeWidth = 2;
    _font = [UIFont systemFontOfSize:17];
    _textAlignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [MAGLabel sizeForText:self.text withFont:self.font andInsets:self.insets];
}

- (void)setText:(NSString *)text {
    if ([text isEqualToString:self.text]) return;
    _text = text;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    if ([font isEqual:self.font]) return;
    _font = font;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setInsets:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(insets, self.insets)) return;
    _insets = insets;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
//    //Bubble drawing
    if (!self.superview) return;
    CGRect strokeRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.strokeWidth, self.strokeWidth, self.strokeWidth, self.strokeWidth));
    UIBezierPath* roundedRectangle4Path = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:INT32_MAX];
    [self.fillColor setFill];
    [roundedRectangle4Path fill];
    [self.strokeColor setStroke];
    roundedRectangle4Path.lineWidth = self.strokeWidth;
    [roundedRectangle4Path stroke];

    //text drawing
    CGRect textRect = UIEdgeInsetsInsetRect(self.bounds, self.insets);
    [self.textColor setFill];
    //TODO: refactor
    [self.text drawInRect:textRect
                 withFont:self.font
            lineBreakMode: NSLineBreakByWordWrapping
                alignment: self.textAlignment];

}


+(CGSize)sizeForText:(NSString*)text withFont:(UIFont*)font andInsets:(UIEdgeInsets)insets {
    CGSize stringSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    stringSize.height += insets.top + insets.bottom;
    stringSize.width += insets.left + insets.right+2;
    return stringSize;
}


@end
