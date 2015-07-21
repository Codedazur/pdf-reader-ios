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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"thumbs-container"]) {
        UIViewController<CDAPdfThumbsViewControllerProtocol> *thumbsVC = [segue destinationViewController];
        [self setThumbsViewController:thumbsVC];
    }else if ([segue.identifier isEqualToString:@"pdf-reader-container"]) {
        UIViewController<CDAPdfReaderProtocol> *pdfVC = [segue destinationViewController];
        [pdfVC setDocumentPath:self.documentPath];
        pdfVC.orientationLayout = self.orientationLayout;
        [self setPdfReaderController:pdfVC];
    }
}

@end
