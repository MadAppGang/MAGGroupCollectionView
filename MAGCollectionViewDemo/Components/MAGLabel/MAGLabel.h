//
//  GALabel.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 10/1/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAGLabel : UIView

//font Insets
@property  (nonatomic, strong) NSString *text;
@property (nonatomic,assign) UIEdgeInsets insets;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *textColor;


+(CGSize)sizeForText:(NSString*)text withFont:(UIFont*)font andInsets:(UIEdgeInsets)insets;
@end
