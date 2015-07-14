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


@interface CDAPDFReaderViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;

@end

@implementation CDAPDFReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGPDFPageRef firstPageRef = [self.readerDocument pageRefForPageIndex:0];
    CDAPDFPageViewController *firstPDFPageViewController = [self createPDFPageViewControllerWithPageRef:firstPageRef andPageIndex:0];
    [self setViewControllers:@[firstPDFPageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public methods

- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
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

- (CDAPDFPageViewController *) createPDFPageViewControllerWithPageRef:(CGPDFPageRef)pageRef andPageIndex:(NSInteger)pageIndex {
    CDAPDFPageViewController *pdfPageViewController;
    
    if (pageRef != NULL) {
        pdfPageViewController = [CDAPDFPageViewController new];
        pdfPageViewController.pageRef = pageRef;
        pdfPageViewController.pageIndex = pageIndex;
    }
    
    return pdfPageViewController;
}

@end
