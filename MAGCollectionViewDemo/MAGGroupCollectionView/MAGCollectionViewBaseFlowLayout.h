//
//  MAGCollectionViewBaseFlowLayout.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 26/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAGCollectionViewFlowLayoutHelper <NSObject>
@end

@interface MAGCollectionViewBaseFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) id<MAGCollectionViewFlowLayoutHelper> layoutHelper;

@end

