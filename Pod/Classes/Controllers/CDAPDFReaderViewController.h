//
//  CDAPDFReaderViewController.h
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import <UIKit/UIKit.h>


@interface CDAPDFReaderViewController : UIPageViewController

/**
 *  Specify the PDF document to be displayed
 *
 *  @param pdfDocumentPath Absolute path of the PDF document
 */
- (void) setDocumentPath:(NSString *)pdfDocumentPath;

@end
