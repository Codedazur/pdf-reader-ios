//
//  CDAPDFPageView.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "CDAPDFPageView.h"
#import "Utilities.h"

@implementation CDAPDFPageView

- (id) initWithFrame:(CGRect)frame andPDFPage:(CGPDFPageRef)pageRef {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.pageRef = pageRef;
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextConcatCTM(ctx, aspectFitTransform(CGPDFPageGetBoxRect(self.pageRef, kCGPDFMediaBox), CGContextGetClipBoundingBox(ctx)));
    CGContextDrawPDFPage(ctx, self.pageRef);
    [super drawRect:rect];
    UIGraphicsEndImageContext();
}

@end
