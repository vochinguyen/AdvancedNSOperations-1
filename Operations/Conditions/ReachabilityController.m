//
//  ReachabilityController.m
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "ReachabilityController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface ReachabilityController()

@property (nonatomic, strong) NSMutableDictionary *reachabilityRefs;

@property (nonatomic, strong) dispatch_queue_t reachabilityQueue;

@end

@implementation ReachabilityController

+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    static ReachabilityController *_shared = nil;
    dispatch_once(&onceToken, ^{
        _shared = [[ReachabilityController alloc] init];
    });
    
    return _shared;
}

- (id)init{
    if (self = [super init]) {
        _reachabilityRefs = [NSMutableDictionary new];
        _reachabilityQueue = dispatch_queue_create("Operations.Reachability", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)requestReachabilityWithURL:(NSURL *)url completionHandler:(void(^)(BOOL reachable))completionHandler{
    NSString *host = [url host];
    if (host) {
        dispatch_async(_reachabilityQueue, ^{
            id ref = self.reachabilityRefs[host];
            
            if (ref == nil) {
                NSString *hostString = host;
                ref = (__bridge id)(SCNetworkReachabilityCreateWithName(nil, [hostString UTF8String]));
            }
            
            if (ref) {
                self.reachabilityRefs[host] = ref;
                
                BOOL reachable = false;
                SCNetworkReachabilityFlags flags = 0;
                if (SCNetworkReachabilityGetFlags((__bridge SCNetworkReachabilityRef)(ref), &flags) != 0) {
                    /*
                     Note that this is a very basic "is reachable" check.
                     Your app may choose to allow for other considerations,
                     such as whether or not the connection would require
                     VPN, a cellular connection, etc.
                     */
                    reachable = flags & kSCNetworkFlagsReachable;
                }
                completionHandler(reachable);
            }
            else {
                completionHandler(false);
            }
        });
    }else {
        completionHandler(false);
    }
}

@end
