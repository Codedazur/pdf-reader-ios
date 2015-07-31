//
//  CDAAbstractPdfReaderViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfReaderWithThumbsViewController.h"
#import "CDAPdfReaderUtils.h"

@interface CDAAbstractPdfReaderWithThumbsViewController ()<CDAPdfReaderDelegateProtocol>

@end

@implementation CDAAbstractPdfReaderWithThumbsViewController
@synthesize thumbsViewController = _thumbsViewController, pdfReaderController = _pdfReaderController, documentPath = _documentPath, orientationLayout = _orientationLayout, initialPageIndex = _initialPageIndex;

- (instancetype)init{
    if(!(self = [super init]))return nil;
    self.initialPageIndex = NSNotFound;
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(!(self = [super initWithCoder:aDecoder]))return nil;
    self.initialPageIndex = NSNotFound;
    return self;
}
- (void)setThumbsViewController:(UIViewController<CDAPdfThumbsViewControllerProtocol> *)thumbsViewController{
    _thumbsViewController = thumbsViewController;
    _thumbsViewController.dataSource = self;
    _thumbsViewController.delegate = self;
}
- (void)setPdfReaderController:(UIViewController<CDAPdfReaderProtocol> *)pdfReaderController{
    _pdfReaderController = pdfReaderController;
    [_pdfReaderController setReaderDelegate:self];
}

#pragma mark - CDAThumbVCDataSource
- (void)thumbsVC:(UIViewController *)thumbsVC setupThumb:(UIView<CDAPdfThumbProtocol> *)thumb OnIndexPath:(NSIndexPath *)indexPath{
    CGPDFPageRef page = [self.pdfReaderController.readerDocument pageRefForPageIndex:indexPath.row];
    [thumb setImage:[CDAPdfReaderUtils thumbImageFromPageRef:page WithFrame:thumb.frame]];
}
- (NSInteger)thumbsVC:(UIViewController *)thumbsVC numberOfItemsInSection:(NSInteger)section{
    return [self.pdfReaderController.readerDocument numberOfPages];
}

#pragma mark - CDAThumbVCDelegate
- (void)thumbsVC:(id)thumbsVC didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pdfReaderController.currentPageIndex = indexPath.row;
}
#pragma mark - CDAPdfReaderDelegateProtocol
- (void)CDAPdfReader:(UIViewController<CDAPdfReaderProtocol> *)pdfReader didChangeToPageIndex:(NSInteger)pageIndex{
    [self.thumbsViewController setCurrentPageIndex:pageIndex];
}
@end
