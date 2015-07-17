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
    self.orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
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
    [self initializeCurrentViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public methods

- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
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

- (BOOL)isCurrentPageOnLeftSide {
    return self.currentPageIndex == 0 || self.currentPageIndex % 2 == 0;
}

- (void) initializeCurrentViewControllers {
    CGPDFPageRef firstPageRef = [self.readerDocument pageRefForPageIndex:self.currentPageIndex];
    CDAPDFPageViewController *firstPDFPageViewController = [self createPDFPageViewControllerWithPageRef:firstPageRef andPageIndex:self.currentPageIndex];
    NSArray *pages = @[firstPDFPageViewController];
    [self setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
