//
//  GAViewController.m
//  MAGCollectionDemo
//
//  Created by Ievgen Rudenko on 9/28/13.
//  Copyright (c) 2013 MadAppGang. All rights reserved.
//

#import "GAMainViewController.h"
#import "MAGLabel.h"
#import "MAGBadgeContainer.h"
#import "GABadge.h"
#import "GALabelCell.h"
#import "GABadgeGroup.h"

@interface GAMainViewController ()

@property (nonatomic, strong) NSMutableArray *testItems;

@end

@implementation GAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillTestData];
}


-(void)fillTestData {
    self.testItems = [[NSMutableArray alloc] initWithCapacity:50];
    for (NSInteger i = 0; i<100; ++i) {
        [self.testItems addObject:[@[[[NSString stringWithFormat:@"This is the %li ",(long)i] stringByPaddingToLength:18+(rand()%20) withString:@"A" startingAtIndex:0]] mutableCopy]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.testItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GALabelCell *cell = (GALabelCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"singleCell" forIndexPath:indexPath];
    cell.items = [self.testItems objectAtIndex:(NSUInteger) indexPath.row];
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.testItems[indexPath.row] count]==1);
}

- (void)collectionView:(UICollectionView *)collectionView didMoveItemFromIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[self.testItems objectAtIndex:(NSUInteger) destinationIndexPath.row] addObjectsFromArray:[self.testItems objectAtIndex:(NSUInteger)sourceIndexPath.row]];
    [self.testItems removeObjectAtIndex:sourceIndexPath.row];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
// Prevent item from being moved to index 0
    if (toIndexPath.row <10) {
        return NO;
    }
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    GABadge *badge = (GABadge *)[cell viewWithTag:1];
    //badge.selected = !badge.selected;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *itemToSize = self.testItems[indexPath.row];
    CGSize result;
    if ([itemToSize count]>1) {
        result = [GABadgeGroup sizeForTextElements:itemToSize
                                        withFont:[GABadge defaultFont]
                                       andInsets:[GABadge defaultInsets]
                                containerMargins:[GABadgeGroup defaultElementMargin]
                                 containerInsets:[GABadgeGroup defaultInsets]];
    } else {
        result = [GABadge sizeForText:self.testItems[indexPath.row][0] withFont:[GABadge defaultFont] andInsets:[GABadge defaultInsets]];
    }
    return result;
}




@end
