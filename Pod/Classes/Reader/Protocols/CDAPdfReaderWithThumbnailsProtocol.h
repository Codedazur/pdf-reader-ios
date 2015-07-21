//
//  CDAPdfReaderProtocol.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAPdfThumbsViewControllerProtocol.h"
#import "CDAPdfReaderProtocol.h"
@protocol CDAPdfReaderWithThumbnailsProtocol <NSObject>
@property (nonatomic, strong) UIViewController<CDAPdfThumbsViewControllerProtocol> *thumbsViewController;
@property (nonatomic, strong) UIViewController<CDAPdfReaderProtocol> *pdfReaderController;
@property (nonatomic, strong) NSString *documentPath;
@property (nonatomic) CDAPDFReaderOrientationLayout orientationLayout;
@end
