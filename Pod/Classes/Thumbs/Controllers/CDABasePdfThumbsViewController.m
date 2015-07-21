//
//  CDAXibThumbsViewController.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABasePdfThumbsViewController.h"
#import "CDABasePdfThumbViewCell.h"
@interface CDABasePdfThumbsViewController ()
@end

@implementation CDABasePdfThumbsViewController
- (void)awakeFromNib{
    [self setCellNibName:NSStringFromClass([CDABasePdfThumbViewCell class])];
}
- (void)viewDidLoad{
    [super viewDidLoad];
}
@end
