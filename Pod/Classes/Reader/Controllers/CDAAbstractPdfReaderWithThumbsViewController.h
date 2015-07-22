//
//  CDAAbstractPdfReaderViewController.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 16/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDAPdfReaderWithThumbnailsProtocol.h"
@interface CDAAbstractPdfReaderWithThumbsViewController : UIViewController<CDAPdfReaderWithThumbnailsProtocol, CDAPdfThumbsDataSourceProtocol, CDAPdfThumbsDelegateProtocol>

@end
