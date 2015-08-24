//
//  ReachabilityController.h
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachabilityController : NSObject

+ (id)sharedInstance;

- (void)requestReachabilityWithURL:(NSURL *)url completionHandler:(void(^)(BOOL reachable))completionHandler;

@end
