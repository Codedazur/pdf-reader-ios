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
 *  @return An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
 */
- (id) initWithPDFDocumentPath:(NSString *) pdfPath;


@end
