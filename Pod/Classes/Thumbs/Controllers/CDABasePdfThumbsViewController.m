//
//  CDAXibThumbsViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABasePdfThumbsViewController.h"
@interface CDABasePdfThumbsViewController ()

@end

@implementation CDABasePdfThumbsViewController
- (UICollectionView *)collectionView{
    return (UICollectionView *)[self.view viewWithTag:1000];
}
- (void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:[self cellIdentifier] bundle:nil];
    [[self collectionView] registerNib:nib forCellWithReuseIdentifier:[self cellIdentifier]];
    [super viewDidLoad];
}
@end
