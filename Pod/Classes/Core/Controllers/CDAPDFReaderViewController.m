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

#import "CDAPDFReaderViewController.h"

#import "CDAPDFReaderDocument.h"
#import "CDAPDFPageViewController.h"


@interface CDAPDFReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) UIPageViewControllerNavigationDirection navigationDirection;

@end

@implementation CDAPDFReaderViewController
@synthesize readerDocument = _readerDocument, orientationLayout = _orientationLayout, currentPageIndex = _currentPageIndex, readerDelegate = _readerDelegate;

#pragma mark - Lifecycle methods

- (instancetype) init {
    if (!(self = [super init])) return nil;
    
    [self initializeInternalProperties];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    [self initializeInternalProperties];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    
    [self initializeInternalProperties];
    
    return self;
}

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options {
    if (!(self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options])) return nil;
    
    [self initializeInternalProperties];
    
    return self;
}

- (void) initializeInternalProperties {
    self.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
    _currentPageIndex = 0;
    self.dataSource = self;
    self.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeCurrentViewControllers];
}


#pragma mark - Public methods

- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
    [self initializeCurrentViewControllers];
}

- (void) setPDFPagesRef:(NSArray *)pdfPagesRef {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFRefPages:pdfPagesRef];
    [self initializeCurrentViewControllers];
}

- (void) setCurrentPageIndex:(NSUInteger)currentPageIndex {
    if(_currentPageIndex == currentPageIndex)return;
    
    if (_currentPageIndex == NSNotFound) {
        self.navigationDirection = UIPageViewControllerNavigationDirectionForward;
    } else if (_currentPageIndex > currentPageIndex) {
        self.navigationDirection = UIPageViewControllerNavigationDirectionReverse;
    } else {
        self.navigationDirection = UIPageViewControllerNavigationDirectionForward;
    }
    
    _currentPageIndex = currentPageIndex;
    [self initializeCurrentViewControllers];
}

- (BOOL) isPortraitLayoutSupported {
    return (self.orientationLayout & CDAPDFReaderOrientationLayoutPortrait) != 0;
}

- (BOOL) isLandscapeLayoutSupported {
    return (self.orientationLayout & CDAPDFReaderOrientationLayoutLandscape) != 0;
}


#pragma mark - UIPageViewController Delegate methods

- (NSUInteger)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    UIInterfaceOrientationMask orientationMask = 0;
    
    if ([self isPortraitLayoutSupported]) orientationMask = orientationMask | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    if ([self isLandscapeLayoutSupported]) orientationMask = orientationMask | UIInterfaceOrientationMaskLandscape;
    
    return orientationMask;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    _currentPageIndex = [[self.viewControllers firstObject] pageIndex];
    if ([self.readerDelegate respondsToSelector:@selector(CDAPdfReader:didChangeToPageIndex:)]) {
        [self.readerDelegate CDAPdfReader:self didChangeToPageIndex:_currentPageIndex];
    }
}


#pragma mark - UIPageViewController DataSource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    CDAPDFPageViewController *pdfPageViewController = (CDAPDFPageViewController *)viewController;
    
    NSInteger nextPageIndex = pdfPageViewController.pageIndex+1;
    CGPDFPageRef nextPageRef = [self.readerDocument pageRefForPageIndex:nextPageIndex];
    
    return [self createPDFPageViewControllerWithPageRef:nextPageRef andPageIndex:nextPageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    CDAPDFPageViewController *pdfPageViewController = (CDAPDFPageViewController *)viewController;
    
    NSInteger previousPageIndex = pdfPageViewController.pageIndex-1;
    CGPDFPageRef previousPageRef = [self.readerDocument pageRefForPageIndex:previousPageIndex];
    
    return [self createPDFPageViewControllerWithPageRef:previousPageRef andPageIndex:previousPageIndex];
}


#pragma mark - Private methods

- (CDAPDFPageViewController *) createPDFPageViewControllerWithPageRef:(CGPDFPageRef)pageRef andPageIndex:(NSInteger)pageIndex {
    CDAPDFPageViewController *pdfPageViewController;
    
    if (pageRef != NULL) {
        pdfPageViewController = [CDAPDFPageViewController new];
        pdfPageViewController.pageRef = pageRef;
        pdfPageViewController.pageIndex = pageIndex;
    }
    
    return pdfPageViewController;
}

- (void) initializeCurrentViewControllers {
    if(!self.readerDocument)return;
    
    CGPDFPageRef firstPageRef = [self.readerDocument pageRefForPageIndex:self.currentPageIndex];
    CDAPDFPageViewController *firstPDFPageViewController = [self createPDFPageViewControllerWithPageRef:firstPageRef andPageIndex:self.currentPageIndex];
    
    if (firstPDFPageViewController == NULL) {
#ifdef DEBUG
        [NSException raise:NSInvalidArgumentException format:@"%@ - Invalid starting page at page index %d. PDF document has %d pages", NSStringFromClass([self class]), self.currentPageIndex, [self.readerDocument numberOfPages]];
#endif
        NSLog(@"ERROR!!! %@ - Invalid starting page at page index %d. PDF document has %d pages", NSStringFromClass([self class]), self.currentPageIndex, [self.readerDocument numberOfPages]);
        return;
    }
    
    // On Scroll Transition style there is a bug that doesn't load correctly the previous page
    if (self.currentPageIndex > 0 && self.transitionStyle == UIPageViewControllerTransitionStyleScroll) {
        NSInteger previousIndex = self.currentPageIndex-1;
        CGPDFPageRef previousPageRef = [self.readerDocument pageRefForPageIndex:previousIndex];
        CDAPDFPageViewController *previousViewController = [self createPDFPageViewControllerWithPageRef:previousPageRef andPageIndex:previousIndex];
        __weak CDAPDFReaderViewController *weakSelf = self;
        [self setViewControllers:@[previousViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            [weakSelf setViewControllers:@[firstPDFPageViewController] direction:weakSelf.navigationDirection animated:YES completion:nil];
        }];
    }
    else {
        [self setViewControllers:@[firstPDFPageViewController] direction:self.navigationDirection animated:YES completion:nil];
    }
}

@end
