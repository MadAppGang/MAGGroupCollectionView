//
//  MAGCollectionViewLeftAllignedFlowLayout.h
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 26/10/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGCollectionViewBaseFlowLayout.h"

@interface MAGCollectionViewLeftAllignedFlowLayout : MAGCollectionViewBaseFlowLayout
@property (nonatomic, assign, getter = isLeftAlligned) BOOL leftAlligned;
@end
