//
//  CDAAbstractPdfReaderViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractPdfReaderWithThumbsViewController.h"


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
    [thumb setImage:[self thumbImageForIndexPath:indexPath WithFrame:thumb.frame]];
}
- (NSInteger)thumbsVC:(UIViewController *)thumbsVC numberOfItemsInSection:(NSInteger)section{
    return [self.pdfReaderController.readerDocument numberOfPages];
}

#pragma mark - CDAThumbVCDelegate
- (void)thumbsVC:(id)thumbsVC didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //TODO throw inheritance exception
}

#pragma mark - Heloper
- (UIImage *)thumbImageForIndexPath:(NSIndexPath *)indexPath WithFrame:(CGRect)frame{
    CGPDFPageRef page = [self.pdfReaderController.readerDocument pageRefForPageIndex:indexPath.row];
    
    CGRect rect = frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, frame.size.width / pageRect.size.width, - frame.size.height / pageRect.size.height);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillEllipseInRect(context, rect);
    CGContextDrawPDFPage(context, page);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
