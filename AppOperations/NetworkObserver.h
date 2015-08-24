//
//  NetworkObserver.h
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "KADOperationObserver.h"

@interface Timer : NSObject

- (id)initWithInterval:(NSTimeInterval)interval handler:(dispatch_block_t)handler;
- (void)cancel;

@end

@interface NetworkIndicatorController : NSObject

+ (id)sharedInstance;


- (void)networkActivityDidStart;

- (void)networkActivityDidEnd;

@end

@interface NetworkObserver : NSObject<KADOperationObserver>

@end
