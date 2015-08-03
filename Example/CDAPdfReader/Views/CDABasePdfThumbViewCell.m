//
//  CDAThumbXibCollectionViewCell.m
//  PDFThumbsTest
//
//  Created by Tamara Bernad on 15/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABasePdfThumbViewCell.h"
@interface CDABasePdfThumbViewCell()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewSelection;

@end
@implementation CDABasePdfThumbViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.viewSelection setHidden:YES];
}
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self.viewSelection setHidden:!selected];
}
- (void)showLoading{
    [self.activityIndicator startAnimating];
}
- (void)hideLoading{
    [self.activityIndicator stopAnimating];
}

@end
