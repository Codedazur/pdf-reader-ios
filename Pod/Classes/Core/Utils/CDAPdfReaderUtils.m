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

#import "CDAPdfReaderUtils.h"

@implementation CDAPdfReaderUtils
+ (UIImage *)thumbImageFromPageRef:(CGPDFPageRef)page WithSize:(CGSize)size AndScreenScale:(CGFloat)screenScale{
    
    CGSize targetThumbSize = [CDAPdfReaderUtils scaledThumbSizeFromPageRef:page WithSize:size Scale:screenScale];
    
    UIGraphicsBeginImageContextWithOptions(targetThumbSize, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, targetThumbSize.height);
    CGContextScaleCTM(context, targetThumbSize.width / pageRect.size.width, - targetThumbSize.height / pageRect.size.height);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, targetThumbSize.width, targetThumbSize.height));
    CGContextDrawPDFPage(context, page);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(CGSize )scaledThumbSizeFromPageRef:(CGPDFPageRef)thePDFPageRef WithSize:(CGSize)size Scale:(CGFloat)screenScale{
    CGFloat thumb_w = size.width; // Maximum thumb width
    CGFloat thumb_h = size.height; // Maximum thumb height
    
    CGRect cropBoxRect = CGPDFPageGetBoxRect(thePDFPageRef, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(thePDFPageRef, kCGPDFMediaBox);
    CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
    
    NSInteger pageRotate = CGPDFPageGetRotationAngle(thePDFPageRef); // Angle
    
    CGFloat page_w = 0.0f; CGFloat page_h = 0.0f; // Rotated page size
    
    switch (pageRotate) // Page rotation (in degrees)
    {
        default: // Default case
        case 0: case 180: // 0 and 180 degrees
        {
            page_w = effectiveRect.size.width;
            page_h = effectiveRect.size.height;
            break;
        }
            
        case 90: case 270: // 90 and 270 degrees
        {
            page_h = effectiveRect.size.width;
            page_w = effectiveRect.size.height;
            break;
        }
    }
    
    CGFloat scale_w = (thumb_w / page_w); // Width scale
    CGFloat scale_h = (thumb_h / page_h); // Height scale
    
    CGFloat scale = 0.0f; // Page to target thumb size scale
    
    if (page_h > page_w)
        scale = ((thumb_h > thumb_w) ? scale_w : scale_h); // Portrait
    else
        scale = ((thumb_h < thumb_w) ? scale_h : scale_w); // Landscape
    
    NSInteger target_w = (page_w * scale); // Integer target thumb width
    NSInteger target_h = (page_h * scale); // Integer target thumb height
    
    if (target_w % 2) target_w--; if (target_h % 2) target_h--; // Even
    
    target_w *= screenScale; target_h *= screenScale; // Screen scale
    return CGSizeMake(target_w, target_h);
}

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
