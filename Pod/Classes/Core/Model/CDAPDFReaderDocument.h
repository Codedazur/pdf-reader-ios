//
//  CDAPDFReaderDocument.h
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

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


@end
