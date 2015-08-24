//
//  KADReachabilityCondition.m
//  AdvancedNSOperation
//
//  Created by Andrey K. on 05.07.15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "KADReachabilityCondition.h"
#import "ReachabilityController.h"

static NSString * hostKey = @"Host";
static NSString * name = @"Reachability";

@interface KADReachabilityCondition ()
{
    NSURL * _host;
}
@end

@implementation KADReachabilityCondition

-(instancetype)initWithHost:(NSURL *)host
{
    if (self = [super init]){
        _host = host;
    }
    return self;
}

#pragma mark - Condition

-(NSString *)name
{
    return NSStringFromClass(self.class);
}

-(BOOL)isMutuallyExclusive
{
    return NO;
}

-(void)evaluateForOperation:(KADOperation *)operation completion:(void (^)(KADOperationConditionResult *))completion
{
    // check reachability for _host via any convenient wrapper and return condition result
    [[ReachabilityController sharedInstance] requestReachabilityWithURL:_host completionHandler:^(BOOL reachable) {
        if (reachable) {
            completion([KADOperationConditionResult satisfied]);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{}];
            
            completion([KADOperationConditionResult failed:error]);
        }
    }];

}

-(NSOperation *)dependencyForOperation:(KADOperation *)operation
{
    return nil;
}

@end
