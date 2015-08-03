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

#import "CDAPdfThumbsCreatorProcessor.h"
#import "CDAPdfThumbCreationTask.h"
#import "CDABGTaskData.h"

@implementation CDAPdfThumbsCreatorProcessor
- (NSOperation<CDABGTaskProtocol> *)createProcessWithData:(NSObject<CDABGTaskDataProtocol> *)processData{
    return [[CDAPdfThumbCreationTask alloc] initWithProcessData:processData];
}
- (void) cancelAllThumbConversionOperations{
    [self.pendingOperations.processesQueue cancelAllOperations];
}
- (void) suspendAllThumbConversionOperations{
    self.pendingOperations.processesQueue.suspended = true;
}
- (void) resumeAllThumbConversionOperations{
    self.pendingOperations.processesQueue.suspended = false;
}
- (void)processThumbsWithPageRefs:(NSArray *)pageRefs ThumbSize:(CGSize)thumbSize ScreenScale:(CGFloat)screenScale ForIndexPaths:(NSArray *)visiblePaths{
    
    NSArray *allPendingOperations = [self.pendingOperations.processesInProgress allKeys];
    
    NSMutableArray *toBeCancelled = [allPendingOperations copy];
    [toBeCancelled removeObjectsInArray:visiblePaths];
    
    NSMutableArray *toBeStarted = [visiblePaths copy];
    [toBeCancelled removeObjectsInArray:allPendingOperations];
    
    
    for (NSIndexPath *indexPath in toBeCancelled) {
        CDAPdfThumbCreationTask *pendingOp = self.pendingOperations.processesInProgress[indexPath];
        if (pendingOp) {
            [pendingOp cancel];
        }
        [self.pendingOperations.processesInProgress removeObjectForKey:indexPath];
    }
    
    for (int i=0;i<toBeStarted.count;i++){
        CDABGTaskData *processData = [[CDABGTaskData alloc] initWithName:@"Process pdf thumb"
                                                             AndUserInfo:@{@"page-ref":[pageRefs objectAtIndex:i],
                                                                           @"thumb-size": [NSValue valueWithCGSize:thumbSize],
                                                                           @"screen-scale":[NSNumber numberWithFloat:screenScale]}];
        
        [self startProcessForData:processData AndKey:[visiblePaths objectAtIndex:i]];
    }
}
@end
