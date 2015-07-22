//
//  CDAAbstractPdfReaderViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfReaderWithThumbsViewController.h"
#import "CDAPdfReaderUtils.h"

@interface CDAAbstractPdfReaderWithThumbsViewController ()

@end

@implementation CDAAbstractPdfReaderWithThumbsViewController
@synthesize thumbsViewController = _thumbsViewController, pdfReaderController = _pdfReaderController, documentPath = _documentPath, orientationLayout = _orientationLayout;

- (void)setThumbsViewController:(UIViewController<CDAPdfThumbsViewControllerProtocol> *)thumbsViewController{
    _thumbsViewController = thumbsViewController;
    _thumbsViewController.dataSource = self;
    _thumbsViewController.delegate = self;
}
- (void)setPdfReaderController:(UIViewController<CDAPdfReaderProtocol> *)pdfReaderController{
    _pdfReaderController = pdfReaderController;
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
    //TODO throw inheritance exception
    self.pdfReaderController.currentPageIndex = indexPath.row;
}
@end
