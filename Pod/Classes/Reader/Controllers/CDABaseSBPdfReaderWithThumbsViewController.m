//
//  CDABaseSBPdfReaderViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABaseSBPdfReaderWithThumbsViewController.h"

@interface CDABaseSBPdfReaderWithThumbsViewController ()
@end

@implementation CDABaseSBPdfReaderWithThumbsViewController

#pragma mark - life cycle
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"thumbs-container"]) {
        UIViewController<CDAPdfThumbsViewControllerProtocol> *thumbsVC = [segue destinationViewController];
        [self setThumbsViewController:thumbsVC];
        [thumbsVC setDocumentPath:self.documentPath];
        if(self.initialPageIndex != NSNotFound)[thumbsVC setCurrentPageIndex:self.initialPageIndex];
    }else if ([segue.identifier isEqualToString:@"pdf-reader-container"]) {
        UIPageViewController<CDAPdfReaderProtocol> *pdfVC = [segue destinationViewController];
        if(self.initialPageIndex != NSNotFound)[pdfVC setCurrentPageIndex:self.initialPageIndex];
        [pdfVC setDocumentPath:self.documentPath];
        pdfVC.orientationLayout = self.orientationLayout;
        [self setPdfReaderController:pdfVC];
    }
}
@end
