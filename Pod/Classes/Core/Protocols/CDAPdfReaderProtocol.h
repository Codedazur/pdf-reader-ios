/*
 
 Copyright (c) 2015 Code d'Azur <info@codedazur.nl>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <Foundation/Foundation.h>
#import "CDAPDFReaderDocument.h"
#import "CDAPDFReaderOrientationLayout.h"
@protocol CDAPdfReaderDelegateProtocol;

@protocol CDAPdfReaderProtocol <NSObject>

@property (nonatomic, weak) NSObject<CDAPdfReaderDelegateProtocol> *readerDelegate;

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

@protocol CDAPdfReaderDelegateProtocol <NSObject>
- (void) CDAPdfReader:(UIViewController<CDAPdfReaderProtocol>*)pdfReader didChangeToPageIndex:(NSInteger)pageIndex;
@end