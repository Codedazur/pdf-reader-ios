//
//  CDAPDFReaderViewController.h
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import <UIKit/UIKit.h>


@interface CDAPDFReaderViewController : UIPageViewController


typedef NS_OPTIONS(NSUInteger, CDAPDFReaderOrientationLayout){
    /// The pages are displayed in portrait when the device is in Portrait or PortraitUpsideDown
    CDAPDFReaderOrientationLayoutPortrait = 1 << 0,
    /// The pages are displayed in landscape when the device is in LandscapeLeft or LandscapeRight
    CDAPDFReaderOrientationLayoutLandscapeOnePage = 1 << 1,
    /// Two pages are displayed in portrait when the device is in LandscapeLeft or LandscapeRight and the transition style is set to Curl. This option prevails over one page landscape
    CDAPDFReaderOrientationLayoutLandscapeTwoPages = 1 << 2
};

/**
 *  The orientation layout supported by the reader.
 *
 *  CDAPDFReaderOrientationLayoutPortrait           -> Portrait
 *
 *  CDAPDFReaderOrientationLayoutLandscapeOnePage   -> Landscape
 *
 *  CDAPDFReaderOrientationLayoutLandscapeTwoPages  -> Landscape showing 2 pages in portrait, one beside the other
 *  This last option requieres the transition style set to Curl, otherwise it won't work.
 *  In case CDAPDFReaderOrientationLayoutLandscapeOnePage and CDAPDFReaderOrientationLayoutLandscapeTwoPages are both specified, the two pages option will prevail
 *
 *  Values can be combined, so can support several layouts at the same time
 *  @code
 *  orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutTwoPages;
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
- (BOOL) isLandscapeOnePageLayoutSupported;
/// Indicate whether the Reader can show two pages when the device is in landscape mode and transition style is curl
- (BOOL) isLandscapeTwoPagesLayoutSupported;

@end
