//
//  CDAPdfThumbCreationTask.m
//  CDABackgroundOperations
//
//  Created by Tamara Bernad on 31/07/15.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAPdfThumbCreationTask.h"
#import "CDAPdfReaderUtils.h"
@implementation CDAPdfThumbCreationTask
- (void)main{
    if (self.cancelled) {
        return;
    }

    CGSize size = [[self.processData.userInfo valueForKey:@"thumb-size"] CGSizeValue];
    CGPDFPageRef page = (__bridge CGPDFPageRef)[self.processData.userInfo valueForKey:@"page-ref"];
    CGFloat screenScale = [[self.processData.userInfo valueForKey:@"screen-scale"] floatValue];
    
    UIImage *img = [CDAPdfReaderUtils thumbImageFromPageRef:page WithSize:size AndScreenScale:screenScale];
    
    [self setResult:img];
}

@end
