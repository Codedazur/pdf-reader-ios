//
//  CDAThumbXibCollectionViewCell.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABasePdfThumbViewCell.h"
@interface CDABasePdfThumbViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation CDABasePdfThumbViewCell
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}
@end
