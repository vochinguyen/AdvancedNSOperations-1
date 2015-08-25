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
            SCNetworkReachabilityRef ref = (__bridge SCNetworkReachabilityRef)self.reachabilityRefs[host];
            
            if (ref == nil) {
                NSString *hostString = host;
                ref = (SCNetworkReachabilityCreateWithName(nil, [hostString UTF8String]));
            }
            
            if (ref) {
                self.reachabilityRefs[host] = (__bridge id)(ref);
                
                BOOL reachable = false;
                SCNetworkReachabilityFlags flags;
                SCNetworkReachabilityGetFlags(ref, &flags);
                if (((flags & kSCNetworkReachabilityFlagsReachable) != 0)) {
                    /*
                     Note that this is a very basic "is reachable" check.
                     Your app may choose to allow for other considerations,
                     such as whether or not the connection would require
                     VPN, a cellular connection, etc.
                     */
                    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
                    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
                    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
                    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
                    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
                    
                    reachable = isNetworkReachable;
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
