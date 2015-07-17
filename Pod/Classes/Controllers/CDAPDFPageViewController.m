//
//  CDAPDFPageViewController.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "CDAPDFPageViewController.h"

#import "CDAPDFPageView.h"
#import "Utilities.h"

@interface CDAPDFPageViewController ()

@property (nonatomic, strong) CDAPDFPageView *pdfPageView;
@property (nonatomic, assign) CDAPDFReaderOrientationLayout orientationLayoutApplied;

@end

@implementation CDAPDFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.pdfPageView == nil && self.pageRef != NULL) {
        [self updatePDFPageViewWithPageRef:self.pageRef];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self applyTransformForOrientationLayout:[self.delegate orientationLayoutForPDFPageViewController:self]];
}

- (void) setPageRef:(CGPDFPageRef)pageRef {
    _pageRef = pageRef;
    if ([self isViewLoaded]) {
        [self updatePDFPageViewWithPageRef:pageRef];
    }
}

- (void) updatePDFPageViewWithPageRef:(CGPDFPageRef)pageRef {
    if (self.pdfPageView.superview != nil) [self.pdfPageView removeFromSuperview];
    CGRect pageRect = CGPDFPageGetBoxRect(self.pageRef, kCGPDFMediaBox);
    self.pdfPageView = [[CDAPDFPageView alloc] initWithFrame:pageRect andPDFPage:self.pageRef];
    [self.view addSubview:self.pdfPageView];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CDAPDFReaderOrientationLayout newOrientationLayout = [self.delegate orientationLayoutForPDFPageViewController:self andInterfaceOrientation:toInterfaceOrientation];
    [self applyTransformForOrientationLayout:newOrientationLayout];
}

- (void) applyTransformForOrientationLayout:(CDAPDFReaderOrientationLayout)orientationLayout {
    if (orientationLayout == CDAPDFReaderOrientationLayoutNone || self.orientationLayoutApplied == orientationLayout) return;
    
    if (self.orientationLayoutApplied != CDAPDFReaderOrientationLayoutNone) {
        CGAffineTransform oldTransform = [self transformForOrientationLayout:self.orientationLayoutApplied];
        self.pdfPageView.transform = CGAffineTransformInvert(oldTransform);
    }
    self.pdfPageView.transform = [self transformForOrientationLayout:orientationLayout];
    
    // TODO: check why the pdfPageView appears missplaced after applying the transformation, so this wouldn't be needed.
    self.pdfPageView.center = CGPointMake(self.pdfPageView.frame.size.width/2, self.pdfPageView.frame.size.height/2);
    
    self.orientationLayoutApplied = orientationLayout;
}

- (CGAffineTransform) transformForOrientationLayout:(CDAPDFReaderOrientationLayout)orientationLayout {
    CGAffineTransform transform;
    
    switch (orientationLayout) {
        case CDAPDFReaderOrientationLayoutPortrait:
            transform = self.pdfPageView.portraitTransform;
            break;
            
        case CDAPDFReaderOrientationLayoutLandscape:
            transform = self.pdfPageView.landscapeTransform;
            break;
            
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    return transform;
}


@end