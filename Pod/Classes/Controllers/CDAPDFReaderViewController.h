//
//  CDAPDFReaderViewController.h
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import <UIKit/UIKit.h>
#import "CDAPDFReaderOrientationLayout.h"


@interface CDAPDFReaderViewController : UIPageViewController

/**
 *  The orientation layout supported by the reader.
 *
 *  CDAPDFReaderOrientationLayoutPortrait           -> Portrait
 *
 *  CDAPDFReaderOrientationLayoutLandscape          -> Landscape
 *
 *
 *  Values can be combined, so can support several layouts at the same time
 *  @code
 *  orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutLandscape;
 *  @endcode
 */
@property (nonatomic, assign) CDAPDFReaderOrientationLayout orientationLayout;


/// The current page index starting from 0, or NSNotFound in case no page is shown
@property (nonatomic, readonly) NSUInteger currentPageIndex;

/**
 *  Specify the PDF document to be displayed
 *
 *  @param pdfDocumentPath Absolute path of the PDF document
 */
- (void) setDocumentPath:(NSString *)pdfDocumentPath;

/// Indicate whether the Reader supports the Portrait orientation layout or not
- (BOOL) isPortraitLayoutSupported;
/// Indicate whether the Reader supports the Landscape orientation layout or not
- (BOOL) isLandscapeLayoutSupported;

@end
