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

@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;
@property (nonatomic, assign) NSUInteger currentPageIndex;

@end

@implementation CDAPDFReaderViewController


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
    self.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscapeOnePage;
    _currentPageIndex = NSNotFound;
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _currentPageIndex = 0;
    CGPDFPageRef firstPageRef = [self.readerDocument pageRefForPageIndex:self.currentPageIndex];
    CDAPDFPageViewController *firstPDFPageViewController = [self createPDFPageViewControllerWithPageRef:firstPageRef andPageIndex:self.currentPageIndex];
    [self setViewControllers:@[firstPDFPageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Getters & Setters

- (void) setOrientationLayout:(CDAPDFReaderOrientationLayout)orientationLayout {
    _orientationLayout = orientationLayout;
    
    if (self.transitionStyle != UIPageViewControllerTransitionStylePageCurl) {
        if ((orientationLayout & CDAPDFReaderOrientationLayoutLandscapeTwoPages) != 0) {
            NSLog(@"WARNING!!! CDAPDFReaderOrientationLayoutLandscapeTwoPages won't work with other transition style rather than Curl.");
        }
    }
    else if ([self isLandscapeOnePageLayoutSupported] && [self isLandscapeTwoPagesLayoutSupported]) {
        NSLog(@"WARNING!!! Both layout orientation options: one page and two pages landscape, are specified. CDAPDFReaderOrientationLayoutLandscapeTwoPages will prevail.");
    }
    
}


#pragma mark - Public methods

- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
}

- (BOOL) isPortraitLayoutSupported {
    return (self.orientationLayout & CDAPDFReaderOrientationLayoutPortrait) != 0;
}

- (BOOL) isLandscapeOnePageLayoutSupported {
    return (self.orientationLayout & CDAPDFReaderOrientationLayoutLandscapeOnePage) != 0;
}

- (BOOL) isLandscapeTwoPagesLayoutSupported {
    return ((self.orientationLayout & CDAPDFReaderOrientationLayoutLandscapeTwoPages) != 0) && (self.transitionStyle == UIPageViewControllerTransitionStylePageCurl);
}


#pragma mark - UIPageViewController Delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    CDAPDFPageViewController *currentPageViewController = (CDAPDFPageViewController *)[self.viewControllers firstObject];
    if (!currentPageViewController) {
        _currentPageIndex = 0;
        currentPageViewController = [self createPDFPageViewControllerWithPageRef:[self.readerDocument pageRefForPageIndex:self.currentPageIndex] andPageIndex:self.currentPageIndex];
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation) && [self isPortraitLayoutSupported]) {
        self.doubleSided = NO;
        [self setViewControllers:@[currentPageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        return UIPageViewControllerSpineLocationMin;
    }
    else if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSArray *viewControllers;
        if ([self isLandscapeTwoPagesLayoutSupported]) {
            if ([self isCurrentPageOnLeftSide]) {
                NSInteger nextPageIndex = self.currentPageIndex + 1;
                CDAPDFPageViewController *nextPageViewController = [self createPDFPageViewControllerWithPageRef:[self.readerDocument pageRefForPageIndex:nextPageIndex]  andPageIndex:nextPageIndex];
                viewControllers = @[currentPageViewController, nextPageViewController];
            }
            else {
                _currentPageIndex--;
                CDAPDFPageViewController *prevPageViewController = [self createPDFPageViewControllerWithPageRef:[self.readerDocument pageRefForPageIndex:self.currentPageIndex]  andPageIndex:self.currentPageIndex];
                viewControllers = @[prevPageViewController, currentPageViewController];
            }
            [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            return UIPageViewControllerSpineLocationMid;
        }
        else if ([self isLandscapeOnePageLayoutSupported]) {
            self.doubleSided = NO;
            [self setViewControllers:@[currentPageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            return UIPageViewControllerSpineLocationMin;
        }
    }
    
    return UIPageViewControllerSpineLocationNone;
}

- (NSUInteger)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController {
    UIInterfaceOrientationMask orientationMask = 0;
    
    if ([self isPortraitLayoutSupported]) orientationMask = orientationMask | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    if ([self isLandscapeOnePageLayoutSupported] || [self isLandscapeTwoPagesLayoutSupported]) orientationMask = orientationMask | UIInterfaceOrientationMaskLandscape;
    
    return orientationMask;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && [self isLandscapeTwoPagesLayoutSupported]) {
        // When two pages are shown, we take the left page as the current one
        _currentPageIndex = [[self.viewControllers objectAtIndex:0] pageIndex];
    }
    else {
        _currentPageIndex = [[self.viewControllers lastObject] pageIndex];
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

- (BOOL)isCurrentPageOnLeftSide {
    return self.currentPageIndex == 0 || self.currentPageIndex % 2 == 0;
}

@end
