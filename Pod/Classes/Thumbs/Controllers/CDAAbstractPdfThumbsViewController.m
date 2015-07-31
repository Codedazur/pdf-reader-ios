//
//  CDABaseThumbsCollectionViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfThumbsViewController.h"

@interface CDAAbstractPdfThumbsViewController ()
@property (nonatomic) NSInteger currentPageIndex;
@end

@implementation CDAAbstractPdfThumbsViewController
@synthesize delegate = _delegate, dataSource = _dataSource;

#pragma mark - polymorphism
- (UICollectionView *)collectionView{
    //TODO overwrite exception
    return nil;
}
- (NSString *)cellIdentifier{
    //TODO overwrite
    return nil;
}

#pragma mark - public
- (void)setCurrentPageIndex:(NSInteger)pageIndex{
    _currentPageIndex = pageIndex;
    [self scrollToPageIndex:pageIndex animated:YES];
}

#pragma mark - life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [self scrollToPageIndex:self.currentPageIndex animated:NO];
}

#pragma mark - collection view Datasource and Delegate
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

#pragma mark - helopers
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated{
    //TODO find a way to check scroll postition depending on the layout used on the collection view
    [[self collectionView] selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPageIndex inSection:0]
                                        animated:animated
                                  scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
@end
