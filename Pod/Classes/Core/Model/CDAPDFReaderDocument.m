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
        NSLog(@"ERROR!!! %@ - Document path can't be a nil or empty string", NSStringFromClass([self class]));
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
        NSLog(@"ERROR!!! %@ - Invalid PDF document: there is no document at %@", NSStringFromClass([self class]), pdfPath);
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

- (id) initWithPDFRefPages:(NSArray *) pdfRefPages {
    if (!(self = [super init])) return nil;
    
    if (pdfRefPages.count == 0) {
#ifdef DEBUG
        [NSException raise:NSInvalidArgumentException format:@"%@ - pdfRefPages can't be empty", NSStringFromClass([self class])];
#endif
        NSLog(@"ERROR!!! %@ - pdfRefPages can't be empty", NSStringFromClass([self class]));
        return nil;
    }
    
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:pdfRefPages.count];
    for (NSInteger i = 0; i < pdfRefPages.count; i++) {
        CGPDFPageRef pageRef = (__bridge CGPDFPageRef)[pdfRefPages objectAtIndex:i];
        
        if (CFGetTypeID(pageRef) == CGPDFPageGetTypeID()) {
            [tempPages addObject:(__bridge id)(pageRef)];
        }
        else {
            pageRef = NULL;
            NSLog(@"WARNING!!! %@ - page at index %d is not a CGPDFPageRef, will try to continue the execution removing this object from the reader.", NSStringFromClass([self class]), i);
        }
    }
    
    if (tempPages.count == 0) {
#ifdef DEBUG
        [NSException raise:NSInvalidArgumentException format:@"%@ - none of the objects passed were a CGPDFPageRef", NSStringFromClass([self class])];
#endif
        NSLog(@"ERROR!!! %@ - none of the objects passed were a CGPDFPageRef", NSStringFromClass([self class]));
        return nil;
    }
    
    self.pdfPages = tempPages;
    _numberOfPages = self.pdfPages.count;
    
    return self;
}


#pragma mark - Public methods

- (CGPDFPageRef) pageRefForPageIndex:(NSInteger)pageIndex {
    if (pageIndex < 0 || pageIndex >= self.pdfPages.count) return NULL;
    
    return (__bridge CGPDFPageRef)[self.pdfPages objectAtIndex:pageIndex];
}

- (NSArray *)pdfPageRefPages{
    return [self.pdfPages copy];
}
@end
