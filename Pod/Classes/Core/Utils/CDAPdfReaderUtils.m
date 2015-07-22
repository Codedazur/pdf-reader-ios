//
//  CDAPdfUtils.m
//  Pods
//
//  Created by Tamara Bernad on 22/07/15.
//
//

#import "CDAPdfReaderUtils.h"

@implementation CDAPdfReaderUtils
+ (UIImage *)thumbImageFromPageRef:(CGPDFPageRef)page WithFrame:(CGRect)frame{
    CGRect rect = frame;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, frame.size.width / pageRect.size.width, - frame.size.height / pageRect.size.height);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillEllipseInRect(context, rect);
    CGContextDrawPDFPage(context, page);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
