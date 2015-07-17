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


@protocol CDAPDFPageViewControllerDelegate;


@interface CDAPDFPageViewController : UIViewController

@property (nonatomic, weak) id<CDAPDFPageViewControllerDelegate> delegate;

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) CGPDFPageRef pageRef;

@end



@protocol CDAPDFPageViewControllerDelegate <NSObject>

- (CDAPDFReaderOrientationLayout) orientationLayoutForPDFPageViewController:(CDAPDFPageViewController *)viewController;
- (CDAPDFReaderOrientationLayout) orientationLayoutForPDFPageViewController:(CDAPDFPageViewController *)viewController andInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end