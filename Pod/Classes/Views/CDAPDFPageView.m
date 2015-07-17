//
//  CDAPDFPageView.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "CDAPDFPageView.h"
#import "Utilities.h"


#define kPORTRAIT_RECT CGRectMake(0, 0, 768, 1024)
#define kLANDSCAPE_RECT CGRectMake(0, 0, 1024, 768)
#define kLANDSCAPE_DOUBLE_SIDED_PAGE_RECT CGRectMake(0, 0, 768, 512)

@interface CDAPDFPageView ()



@end

@implementation CDAPDFPageView

- (id) initWithFrame:(CGRect)frame andPDFPage:(CGPDFPageRef)pageRef {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.pageRef = pageRef;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGRect pageRect = CGPDFPageGetBoxRect(self.pageRef, kCGPDFMediaBox);
    CGContextConcatCTM(ctx, pdfAspectFitTransform(pageRect, CGContextGetClipBoundingBox(ctx)));
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, pageRect);
    CGContextDrawPDFPage(ctx, self.pageRef);
    [super drawRect:rect];
    UIGraphicsEndImageContext();
    
}


@end
