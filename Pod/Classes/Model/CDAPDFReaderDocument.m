//
//  CDAPDFReaderDocument.m
//  Pods
//
//  Created by Gerardo Garrido on 13/07/15.
//
//

#import "CDAPDFReaderDocument.h"

@import QuartzCore;


@interface CDAPDFReaderDocument ()

@property (nonatomic, strong) NSArray *pdfPages;


@end

@implementation CDAPDFReaderDocument


#pragma mark - Lifecycle methods

- (id) initWithPDFDocumentPath:(NSString *) pdfPath {
    if (!(self = [super init])) return nil;
    
    if (!pdfPath || pdfPath.length == 0) {
#ifdef DEBUG
        [NSException raise:NSGenericException format:@"%@ - Document path can't be a nil or empty string", NSStringFromClass([self class])];
#endif
        NSLog(@"%@ - Document path can't be a nil or empty string", NSStringFromClass([self class]));
        return nil;
    }
    
    const char *filepath = [pdfPath cStringUsingEncoding:NSASCIIStringEncoding];
    CFStringRef path = CFStringCreateWithCString(NULL, filepath, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    
    CFRelease(path);
    
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    if (document == NULL) {
#ifdef DEBUG
        [NSException raise:NSGenericException format:@"%@ - Invalid PDF document: there is no document at %@", NSStringFromClass([self class]),  pdfPath];
#endif
        NSLog(@"%@ - Invalid PDF document: there is no document at %@", NSStringFromClass([self class]), pdfPath);
        CGPDFDocumentRelease(document);
        return nil;
    }
    
    _numberOfPages = CGPDFDocumentGetNumberOfPages(document);
    
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    for (NSInteger i = 1; i <= self.numberOfPages; i++) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, i);
        [tempPages addObject:(__bridge id)(pageRef)];
    }
    
    self.pdfPages = tempPages;
    
    CGPDFDocumentRelease(document);
    
    return self;
}


#pragma mark - Public methods

- (CGPDFPageRef) pageRefForPageIndex:(NSInteger)pageIndex {
    if (pageIndex < 0 || pageIndex >= self.pdfPages.count) return NULL;
    
    return (__bridge CGPDFPageRef)[self.pdfPages objectAtIndex:pageIndex];
}

@end
