//
// Created by Ievgen Rudenko on 10/12/13.
// Copyright (c) 2013 MadAppGang. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIColor+GAHEX.h"


@implementation UIColor (GAHEX)

 + (UIColor*)colorWithRGBA:(NSUInteger) color
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}

+ (UIColor*)colorWithRGB:(NSUInteger) color
{
    return [UIColor colorWithRed:((color >> 16) & 0xFF) / 255.0f
                           green:((color >> 8) & 0xFF) / 255.0f
                            blue:((color) & 0xFF) / 255.0f
                           alpha:255.0f];
}

@end