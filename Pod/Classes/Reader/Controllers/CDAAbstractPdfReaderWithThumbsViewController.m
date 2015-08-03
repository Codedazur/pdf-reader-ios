/*
 
 Copyright (c) 2015 Code d'Azur <info@codedazur.nl>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CDAAbstractPdfReaderWithThumbsViewController.h"
#import "CDAPdfReaderUtils.h"

@interface CDAAbstractPdfReaderWithThumbsViewController ()<CDAPdfReaderDelegateProtocol>

@end

@implementation CDAAbstractPdfReaderWithThumbsViewController
@synthesize thumbsViewController = _thumbsViewController, pdfReaderController = _pdfReaderController, documentPath = _documentPath, orientationLayout = _orientationLayout, initialPageIndex = _initialPageIndex;

#pragma mark - life cycle
- (instancetype)init{
    if(!(self = [super init]))return nil;
    self.initialPageIndex = NSNotFound;
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(!(self = [super initWithCoder:aDecoder]))return nil;
    self.initialPageIndex = NSNotFound;
    return self;
}

#pragma mark - public
- (void)setThumbsViewController:(UIViewController<CDAPdfThumbsViewControllerProtocol> *)thumbsViewController{
    _thumbsViewController = thumbsViewController;
    _thumbsViewController.delegate = self;
}
- (void)setPdfReaderController:(UIViewController<CDAPdfReaderProtocol> *)pdfReaderController{
    _pdfReaderController = pdfReaderController;
    [_pdfReaderController setReaderDelegate:self];
}

#pragma mark - CDAThumbVCDelegate
- (void)thumbsVC:(id)thumbsVC didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pdfReaderController.currentPageIndex = indexPath.row;
}
#pragma mark - CDAPdfReaderDelegateProtocol
- (void)CDAPdfReader:(UIViewController<CDAPdfReaderProtocol> *)pdfReader didChangeToPageIndex:(NSInteger)pageIndex{
    [self.thumbsViewController setCurrentPageIndex:pageIndex];
}

@end
