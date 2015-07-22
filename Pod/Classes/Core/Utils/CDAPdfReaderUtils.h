//
//  CDAPdfUtils.h
//  Pods
//
//  Created by Tamara Bernad on 22/07/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CDAPdfReaderUtils : NSObject
+ (UIImage *)thumbImageFromPageRef:(CGPDFPageRef)pageRef WithFrame:(CGRect)frame;
@end
