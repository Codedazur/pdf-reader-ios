/*
 
 Copyright (c) 2015 Code d'Azur <info@codedazur.nl>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CDAPDFPageViewController.h"

#import "CDAPDFReaderContentView.h"

@interface CDAPDFPageViewController ()

@property (nonatomic, strong) CDAPDFReaderContentView *pdfPageView;
@end

@implementation CDAPDFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.pdfPageView == nil && self.pageRef != NULL) {
        [self updatePDFPageViewWithPageRef:self.pageRef];
    }
}

- (void) setPageRef:(CGPDFPageRef)pageRef {
    _pageRef = pageRef;
    if ([self isViewLoaded]) {
        [self updatePDFPageViewWithPageRef:pageRef];
    }
}

- (void) updatePDFPageViewWithPageRef:(CGPDFPageRef)pageRef {
    if (self.pdfPageView.superview != nil) [self.pdfPageView removeFromSuperview];
    self.pdfPageView = [[CDAPDFReaderContentView alloc] initWithFrame:self.view.bounds PageRef:pageRef page:0 password:@""];
    [self.view addSubview:self.pdfPageView];
}


@end
