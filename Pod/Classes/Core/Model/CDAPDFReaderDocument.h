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

@interface CDAPDFReaderDocument : NSObject

/// Number of the pages of the PDF document
@property (nonatomic, assign, readonly) NSInteger numberOfPages;

/**
 *  Specify the PDF document to be displayed
 *
 *  @param pdfDocumentPath Absolute path of the PDF document
 *  
 *  @return An initialized object, or nil if an object could not be created (in case of debugging it will arise and exception instead).
 */
- (id) initWithPDFDocumentPath:(NSString *) pdfPath;

/**
 *  Specify a group of CGPDFPageRef to be shown as a normal PDF document, even if they exist just in memory.
 *
 *  @param pdfRefPages An array of CGPDFPageRef
 *
 *  @return An initialized object, or nil if an object could not be created (in case of debugging it will arise and exception instead).
 */
- (id) initWithPDFRefPages:(NSArray *) pdfRefPages;

/**
 *  Return the specified PDF page of the PDF document passed in the constructor.
 *
 *  @param pageIndex the number of the desired page starting from 0.
 *
 *  @return The related CGPDFPageRef to the indicated pageIndex, or nil if the pageIndex is out of range.
 */
- (CGPDFPageRef) pageRefForPageIndex:(NSInteger)pageIndex;

/**
 Retruns a copy of the CGPDFPageRef available in the document
 */

- (NSArray *)pdfPageRefPages;
@end
