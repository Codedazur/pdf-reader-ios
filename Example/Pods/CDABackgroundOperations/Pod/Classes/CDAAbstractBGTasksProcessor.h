//
//  CDAProcessProcessor.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDABGTasksProcessorProtocol.h"
#import "CDABGTaskProtocol.h"

@interface CDAAbstractBGTasksProcessor : NSObject<CDABGTasksProcessorProtocol>
- (void)startProcessForData:(NSObject<CDABGTaskDataProtocol> *)processData AndKey:(id <NSCopying>)key;
- (NSOperation<CDABGTaskProtocol> *)createProcessWithData:(NSObject<CDABGTaskDataProtocol> *)processData;
@end
