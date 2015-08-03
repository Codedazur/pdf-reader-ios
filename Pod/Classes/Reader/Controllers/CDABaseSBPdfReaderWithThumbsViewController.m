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

#import "CDABaseSBPdfReaderWithThumbsViewController.h"

@interface CDABaseSBPdfReaderWithThumbsViewController ()
@end

@implementation CDABaseSBPdfReaderWithThumbsViewController

#pragma mark - life cycle
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"thumbs-container"]) {
        UIViewController<CDAPdfThumbsViewControllerProtocol> *thumbsVC = [segue destinationViewController];
        [self setThumbsViewController:thumbsVC];
        [thumbsVC setDocumentPath:self.documentPath];
        if(self.initialPageIndex != NSNotFound)[thumbsVC setCurrentPageIndex:self.initialPageIndex];
    }else if ([segue.identifier isEqualToString:@"pdf-reader-container"]) {
        UIPageViewController<CDAPdfReaderProtocol> *pdfVC = [segue destinationViewController];
        if(self.initialPageIndex != NSNotFound)[pdfVC setCurrentPageIndex:self.initialPageIndex];
        [pdfVC setDocumentPath:self.documentPath];
        pdfVC.orientationLayout = self.orientationLayout;
        [self setPdfReaderController:pdfVC];
    }
}
@end
