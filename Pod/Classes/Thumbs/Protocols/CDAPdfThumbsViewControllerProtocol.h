//
//  CDAPdfThumbsViewControllerProtocol.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAPdfThumbsDataSourceProtocol.h"
#import "CDAPdfThumbsDelegateProtocol.h"
@protocol CDAPdfThumbsViewControllerProtocol <NSObject>
@property (nonatomic, weak) NSObject<CDAPdfThumbsDelegateProtocol> *delegate;
@property (nonatomic, weak) NSObject<CDAPdfThumbsDataSourceProtocol> *dataSource;
- (void) setCurrentPageIndex:(NSInteger)pageIndex;
@end
