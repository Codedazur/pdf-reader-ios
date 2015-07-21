//
//  CDABaseThumbsCollectionViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfThumbsViewController.h"

@interface CDAAbstractPdfThumbsViewController ()
@property (nonatomic, strong)NSString *cellNibName;
@end

@implementation CDAAbstractPdfThumbsViewController
@synthesize delegate = _delegate, dataSource = _dataSource;

- (UICollectionView *)collectionView{
    //TODO overwrite exception
    return nil;
}
- (void) setCellNibName:(NSString *)nibName{
    _cellNibName = nibName;
}
- (void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:self.cellNibName bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.cellNibName];
    
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell<CDAPdfThumbProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellNibName forIndexPath:indexPath];
    
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
