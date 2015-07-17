//
//  CDAPDFPageViewController.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "CDAPDFPageViewController.h"

#import "ReaderContentView.h"
#import "Utilities.h"

@interface CDAPDFPageViewController ()

//@property (nonatomic, strong) CDAPDFPageView *pdfPageView;
@property (nonatomic, strong) ReaderContentView *pdfPageView;
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
//    self.pdfPageView = [[CDAPDFPageView alloc] initWithFrame:self.view.bounds andPDFPage:self.pageRef];
    self.pdfPageView = [[ReaderContentView alloc] initWithFrame:self.view.bounds PageRef:pageRef page:0 password:@""];
    [self.view addSubview:self.pdfPageView];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updatePDFPageViewWithPageRef:self.pageRef];
}

@end
