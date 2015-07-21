//
//  CDABaseThumbsCollectionViewController.h
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDAPdfThumbsViewControllerProtocol.h"
@interface CDAAbstractPdfThumbsViewController : UIViewController<CDAPdfThumbsViewControllerProtocol,UICollectionViewDelegate, UICollectionViewDataSource>
- (UICollectionView *)collectionView;
- (void) setCellNibName:(NSString *)nibName;
@end
