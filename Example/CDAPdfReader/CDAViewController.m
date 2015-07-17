//
//  CDAViewController.m
//  CDAPdfReader
//
//  Created by tamarabernad on 07/13/2015.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAViewController.h"

@import CDAPdfReader;

@interface CDAViewController ()

@end

@implementation CDAViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"storyboardImplementation"]) {
        CDAPDFReaderViewController *viewController = (CDAPDFReaderViewController *)segue.destinationViewController;
        NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];
        [viewController setDocumentPath:documentPath];
        viewController.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
    }
}

@end
