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
 *  The orientation layout supported by the reader.
 *  The possible values are:
 *      CDAPDFReaderOrientationLayoutPortrait   -> Portrait
 *      CDAPDFReaderOrientationLayoutLandscape  -> Landscape
 *      CDAPDFReaderOrientationLayoutTwoPages   -> Landscape showing 2 pages in portrait, one beside the other
 */
typedef NS_OPTIONS(NSUInteger, CDAPDFReaderOrientationLayout){
    /// The pages are displayed in portrait when the device is in Portrait or PortraitUpsideDown
    CDAPDFReaderOrientationLayoutPortrait = 1 << 0,
    /// The pages are displayed in landscape when the device is in LandscapeLeft or LandscapeRight
    CDAPDFReaderOrientationLayoutLandscape = 1 << 1,
    /// Two pages are displayed in portrait when the device is in LandscapeLeft or LandscapeRight
    CDAPDFReaderOrientationLayoutTwoPages = 1 << 2
};

/**
 *  The orientation layout supported by the reader.
 *  The possible values are:
 *      CDAPDFReaderOrientationLayoutPortrait   -> Portrait
 *      CDAPDFReaderOrientationLayoutLandscape  -> Landscape
 *      CDAPDFReaderOrientationLayoutTwoPages   -> Landscape showing 2 pages in portrait, one beside the other
 *
 *  Values can be combined, so can support several layouts at the same time
 *  @code
 *      orientationLayout = CDAPDFReaderOrientationLayoutPortrait | CDAPDFReaderOrientationLayoutTwoPages;
 *  @endcode
 */
@property (nonatomic, assign) CDAPDFReaderOrientationLayout orientationLayout;

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
/// Indicate whether the Reader can show two pages when the device is in landscape mode
- (BOOL) isTwoPagesLayoutSupported;

@end
