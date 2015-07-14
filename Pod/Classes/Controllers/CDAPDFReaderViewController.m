//
//  CDAPDFReaderViewController.m
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import "CDAPDFReaderViewController.h"

#import "CDAPDFReaderDocument.h"


@interface CDAPDFReaderViewController ()

@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;
@property (nonatomic, strong) IBInspectable NSString *documentPath;

@end

@implementation CDAPDFReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public methods

- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    NSString *absolutePath;
    
    pdfDocumentPath = [pdfDocumentPath stringByDeletingPathExtension];
    
    NSArray *pathComponents = [pdfDocumentPath pathComponents];
    
    if (pathComponents.count == 1) {
        absolutePath = [[NSBundle mainBundle] pathForResource:pdfDocumentPath ofType:@"pdf"];
    }
    else {
        absolutePath = pdfDocumentPath;
    }
    
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:absolutePath];
}

@end
