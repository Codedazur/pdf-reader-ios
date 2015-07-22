//
//  CDAViewController.m
//  CDAPdfReader
//
//  Created by tamarabernad on 07/13/2015.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAViewController.h"
#import "CDAPDFReaderViewController.h"
#import "CDABaseSBPdfReaderWithThumbsViewController.h"
//@import CDAPdfReader;

@interface CDAViewController ()

@end

@implementation CDAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];
    CDAPDFReaderDocument *d = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:documentPath];
    NSArray *copyPageRefs = [d pdfPageRefPages];
    NSLog(@"pages in reader document %i", copyPageRefs.count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"storyboardImplementation"]) {
        CDAPDFReaderViewController *viewController = (CDAPDFReaderViewController *)segue.destinationViewController;
        NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];
        [viewController setDocumentPath:documentPath];
        viewController.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
    }else if([segue.identifier isEqualToString:@"with-thumbs"]){
        CDABaseSBPdfReaderWithThumbsViewController *viewController = (CDABaseSBPdfReaderWithThumbsViewController *)segue.destinationViewController;
        NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];

        [viewController setDocumentPath:documentPath];
        viewController.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
    }
    else if ([segue.identifier isEqual:@"arrayPagesImplementation"]) {
        CDAPDFReaderViewController *viewController = (CDAPDFReaderViewController *)segue.destinationViewController;
        NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];
        const char *filepath = [pdfPath cStringUsingEncoding:NSASCIIStringEncoding];
        CFStringRef path = CFStringCreateWithCString(NULL, filepath, kCFStringEncodingUTF8);
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
        
        CFRelease(path);
        
        CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
        CFRelease(url);
        
        NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(document);
        
        NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:numberOfPages];
        [tempPages addObject:@"This is not a CGPDFPageRef"];
        for (NSInteger i = 1; i <= 10; i++) {
            CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, i);
            [tempPages addObject:(__bridge id)(pageRef)];
        }
        [viewController setPDFPagesRef:tempPages];
        viewController.orientationLayout = CDAPDFReaderOrientationLayoutPortrait;
    }
}

@end
