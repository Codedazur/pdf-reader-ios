//
//  CDAPDFReaderViewController.m
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import "CDAPDFReaderViewController.h"

#import "CDAPDFReaderDocument.h"
#import "CDAPDFPageViewController.h"


@interface CDAPDFReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

//@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;

@end

@implementation CDAPDFReaderViewController
@synthesize readerDocument = _readerDocument, orientationLayout = _orientationLayout, currentPageIndex = _currentPageIndex;

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
        [NSException raise:NSInvalidArgumentException format:@"%@ - Invalid starting page at page index %ld. PDF document has %lu pages", NSStringFromClass([self class]), self.currentPageIndex, [self.readerDocument numberOfPages]];
#endif
        NSLog(@"ERROR!!! %@ - Invalid starting page at page index %ld. PDF document has %lu pages", NSStringFromClass([self class]), self.currentPageIndex, [self.readerDocument numberOfPages]);
        return;
    }
    NSArray *pages = @[firstPDFPageViewController];
    [self setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
