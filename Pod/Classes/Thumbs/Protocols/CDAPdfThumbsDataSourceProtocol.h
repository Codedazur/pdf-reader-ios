//
//  CDAThumbVCDataSource.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDAPdfThumbCellProtocol.h"

@protocol CDAPdfThumbsDataSourceProtocol <NSObject>
- (NSInteger) thumbsVC:(UIViewController *)thumbsVC numberOfItemsInSection:(NSInteger)section;
- (void)thumbsVC:(UIViewController *)thumbsVC setupThumb:(UIView<CDAPdfThumbProtocol> *)thumb OnIndexPath:(NSIndexPath *)indexPath;
@end
