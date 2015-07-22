//
//  CDAThumbVCDelegate.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CDAPdfThumbsDelegateProtocol <NSObject>
- (void)thumbsVC:(UIViewController *)thumbsVC didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end
