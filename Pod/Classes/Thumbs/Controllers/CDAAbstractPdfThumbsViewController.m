/*
 
 Copyright (c) 2015 Code d'Azur <info@codedazur.nl>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CDAAbstractPdfThumbsViewController.h"

@interface CDAAbstractPdfThumbsViewController ()
@property (nonatomic) NSInteger currentPageIndex;
@end

@implementation CDAAbstractPdfThumbsViewController
@synthesize delegate = _delegate, dataSource = _dataSource;

#pragma mark - polymorphism
- (void)setDocumentPath:(NSString *)pdfDocumentPath{
    //TODO throw override exception
}
- (UICollectionView *)collectionView{
    //TODO throw override exception
    return nil;
}
- (NSString *)cellIdentifier{
    //TODO throw override exception
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
    if([self.dataSource thumbsVC:self numberOfItemsInSection:0] <= pageIndex)return;
    //TODO find a way to check scroll postition depending on the layout used on the collection view
    [[self collectionView] selectItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]
                                        animated:animated
                                  scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}
@end
