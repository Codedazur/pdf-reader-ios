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
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
}

@end
