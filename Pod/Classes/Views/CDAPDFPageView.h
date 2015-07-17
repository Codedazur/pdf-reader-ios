//
//  CDAPDFPageView.h
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import <UIKit/UIKit.h>

@import QuartzCore;

@interface CDAPDFPageView : UIView

@property (assign, nonatomic) CGPDFPageRef pageRef;

@property (nonatomic, assign) CGAffineTransform portraitTransform;
@property (nonatomic, assign) CGAffineTransform landscapeOnePageTransform;
@property (nonatomic, assign) CGAffineTransform landscapeTwoPagesTransform;

- (id) initWithFrame:(CGRect)frame andPDFPage:(CGPDFPageRef)pageRef;

@end
