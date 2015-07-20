//
//  CDAPDFPageViewController.h
//  Pods
//
//  Created by Gerardo Garrido on 14/07/15.
//
//

#import <UIKit/UIKit.h>
#import "CDAPDFReaderOrientationLayout.h"

@import QuartzCore;


@interface CDAPDFPageViewController : UIViewController


@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) CGPDFPageRef pageRef;

@end