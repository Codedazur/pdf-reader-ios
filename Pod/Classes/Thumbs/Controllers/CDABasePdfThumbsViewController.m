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
#import "CDABasePdfThumbsViewController.h"
#import "CDAPdfThumbsCreatorProcessor.h"

@interface CDABasePdfThumbsViewController ()<CDABGTasksProcessorDelegate, CDAPdfThumbsDataSourceProtocol>
@property (nonatomic, strong) CDAPdfThumbsCreatorProcessor *thumbsCreationProcessor;
//TODO use NSCache
@property (nonatomic, strong) NSArray *pdfImages;
@property (nonatomic, strong) CDAPDFReaderDocument *readerDocument;
@end

@implementation CDABasePdfThumbsViewController

#pragma mark - lazy getters
- (NSArray *)images{
    if(!_pdfImages){
        NSMutableArray *images = [NSMutableArray new];
        for(int i=0;i<[self.readerDocument numberOfPages];i++){
            [images addObject:[NSNull null]];
        }
        _pdfImages = [NSArray arrayWithArray:images];
    }
    return _pdfImages;
}
- (CDAPdfThumbsCreatorProcessor *)thumbsCreationProcessor{
    if(!_thumbsCreationProcessor){
        _thumbsCreationProcessor = [CDAPdfThumbsCreatorProcessor new];
        _thumbsCreationProcessor.delegate = self;
    }
    return _thumbsCreationProcessor;
}
#pragma mark - polimorphysm
- (void) setDocumentPath:(NSString *)pdfDocumentPath {
    self.readerDocument = [[CDAPDFReaderDocument alloc] initWithPDFDocumentPath:pdfDocumentPath];
    _pdfImages = nil;
    [[self collectionView] reloadData];
}
- (UICollectionView *)collectionView{
    return (UICollectionView *)[self.view viewWithTag:1000];
}
- (void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:[self cellIdentifier] bundle:nil];
    [[self collectionView] registerNib:nib forCellWithReuseIdentifier:[self cellIdentifier]];
    [self setDataSource:self];
    [super viewDidLoad];
}

#pragma mark - scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.thumbsCreationProcessor suspendAllThumbConversionOperations];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self loadThumbsForOnscreenCells];
        [self.thumbsCreationProcessor resumeAllThumbConversionOperations];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadThumbsForOnscreenCells];
    [self.thumbsCreationProcessor resumeAllThumbConversionOperations];
}
#pragma mark - CDAProcessorDelegate
- (void)CDABGTasksProcessor:(NSObject<CDABGTasksProcessorProtocol> *)processor DidFinishWithProcessData:(NSObject<CDABGTaskDataProtocol> *)processData AndKey:(id <NSCopying>)key{
    NSIndexPath *indexPath = (NSIndexPath *)key;
    NSMutableArray *images = [self.pdfImages mutableCopy];
    [images replaceObjectAtIndex:indexPath.row withObject:processData.result];
    self.pdfImages = [images copy];
    

    //Hack for the selection state which does some flickering because reloadItemsAtIndexPaths regenerates the whole cell
    BOOL isSelected = [[self.collectionView indexPathsForSelectedItems] indexOfObject:indexPath] != NSNotFound;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if (isSelected) {
        [UIView setAnimationsEnabled:NO];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [UIView setAnimationsEnabled:YES];
    }
}

#pragma mark - Helpers
- (void)loadThumbsForOnscreenCells{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSMutableArray *pageRefs = [NSMutableArray new];
    for(NSIndexPath *indexPath in indexPaths){
        [pageRefs addObject:(__bridge id)[self.readerDocument pageRefForPageIndex:indexPath.row]];
    }
    [self.thumbsCreationProcessor processThumbsWithPageRefs:pageRefs ThumbSize:CGSizeMake(100, 100) ScreenScale:1.0 ForIndexPaths:indexPaths];
}

#pragma mark - CDAThumbVCDataSource
- (void)thumbsVC:(UIViewController *)thumbsVC setupThumb:(UIView<CDAPdfThumbProtocol> *)thumb OnIndexPath:(NSIndexPath *)indexPath{
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    img = [img isEqual:[NSNull null]] ? nil : img;
    if(!img){
        [thumb showLoading];
        [self.thumbsCreationProcessor processThumbsWithPageRefs:@[(__bridge id)[self.readerDocument pageRefForPageIndex:indexPath.row]] ThumbSize:CGSizeMake(100, 100) ScreenScale:1.0 ForIndexPaths:@[indexPath]];
    }else{
        [thumb hideLoading];
    }
    [thumb setImage:img];
}
- (NSInteger)thumbsVC:(UIViewController *)thumbsVC numberOfItemsInSection:(NSInteger)section{
    return [self.readerDocument numberOfPages];
}

@end
