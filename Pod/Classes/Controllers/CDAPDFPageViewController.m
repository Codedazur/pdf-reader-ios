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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setPageRef:(CGPDFPageRef)pageRef {
    _pageRef = pageRef;
    if ([self isViewLoaded]) {
        [self updatePDFPageViewWithPageRef:pageRef];
    }
}

- (void) updatePDFPageViewWithPageRef:(CGPDFPageRef)pageRef {
    if (self.pdfPageView.superview != nil) [self.pdfPageView removeFromSuperview];
    self.pdfPageView = [[CDAPDFPageView alloc] initWithFrame:self.view.bounds andPDFPage:self.pageRef];
    [self.view addSubview:self.pdfPageView];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self applyTransform];
}

- (void) applyTransform {
    CDAPDFReaderOrientationLayout newOrientationLayout = [self.delegate orientationLayoutForPDFPageViewController:self];
    if (newOrientationLayout == self.orientationLayoutApplied) return;
    
    if (self.orientationLayoutApplied != CDAPDFReaderOrientationLayoutNone) {
        self.view.transform = CGAffineTransformInvert([self transformForOrientationLayout:self.orientationLayoutApplied]);
    }
    self.view.transform = [self transformForOrientationLayout:newOrientationLayout];
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
