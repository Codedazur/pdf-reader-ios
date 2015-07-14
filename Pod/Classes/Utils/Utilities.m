//
//  Utilities.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "Utilities.h"

CGAffineTransform aspectFitTransform(CGRect innerRect, CGRect outerRect) {
    CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
    CGAffineTransform translation =
    CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x,
                                     (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
    return CGAffineTransformConcat(scale, translation);
}
