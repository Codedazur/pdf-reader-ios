//
//  Utilities.m
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import "Utilities.h"

CGAffineTransform pdfAspectFitTransform(CGRect pdfRect, CGRect screenRect) {
    CGFloat scaleFactor = MIN(screenRect.size.width/pdfRect.size.width, screenRect.size.height/pdfRect.size.height);
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGRect scaledPDFRect = CGRectApplyAffineTransform(pdfRect, scale);
    
    CGAffineTransform translation =
    CGAffineTransformMakeTranslation((screenRect.size.width - scaledPDFRect.size.width) / 2 - scaledPDFRect.origin.x,
                                     (screenRect.size.height - scaledPDFRect.size.height) / 2 - scaledPDFRect.origin.y);
    return CGAffineTransformConcat(scale, translation);
}

/// A transform with all its values set to 0. This is the default value for a CGAffineTransform not initlaized yet.
CGAffineTransform CGAffineTransformZero () {
    return CGAffineTransformFromString(@"{0, 0, 0, 0, 0, 0}");
}
