//
//  CDAPdfReaderProtocol.h
//  Pods
//
//  Created by Tamara Bernad on 21/07/15.
//
//

#import <Foundation/Foundation.h>
#import "CDAPDFReaderDocument.h"
#import "CDAPDFReaderOrientationLayout.h"

@protocol CDAPdfReaderProtocol <NSObject>
@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;
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
@property (nonatomic, assign) NSUInteger currentPageIndex;

/**
 *  Specify the PDF document to be displayed
 *
 *  @param pdfDocumentPath Absolute path of the PDF document
 */
- (void) setDocumentPath:(NSString *)pdfDocumentPath;

/**
 *  Specify a group of CGPDFPageRef to be shown as a normal PDF document, even if they exist just in memory.
 *
 *  @param pdfPagesRef An array of CGPDFPageRef
 */
- (void) setPDFPagesRef:(NSArray *)pdfPagesRef;

/// Indicate whether the Reader supports the Portrait orientation layout or not
- (BOOL) isPortraitLayoutSupported;
/// Indicate whether the Reader supports the Landscape orientation layout or not
- (BOOL) isLandscapeLayoutSupported;

@end
