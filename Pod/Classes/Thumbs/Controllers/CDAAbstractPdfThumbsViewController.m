//
//  CDABaseThumbsCollectionViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfThumbsViewController.h"

@interface CDAAbstractPdfThumbsViewController ()

@end

@implementation CDAAbstractPdfThumbsViewController
@synthesize delegate = _delegate, dataSource = _dataSource;

- (UICollectionView *)collectionView{
    //TODO overwrite exception
    return nil;
}
- (NSString *)cellIdentifier{
    //TODO overwrite
    return nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell<CDAPdfThumbProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    
    [self.dataSource thumbsVC:self setupThumb:cell OnIndexPath:indexPath];

    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource thumbsVC:self numberOfItemsInSection:section];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate thumbsVC:self didSelectItemAtIndexPath:indexPath];
}
@end
