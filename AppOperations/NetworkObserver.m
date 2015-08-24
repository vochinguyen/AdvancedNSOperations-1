//
//  NetworkObserver.m
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "NetworkObserver.h"
#import <UIKit/UIKit.h>

@implementation NetworkObserver

- (void)operationDidStart:(KADOperation *)operation{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Increment the network indicator's "reference count"
        [[NetworkIndicatorController sharedInstance] networkActivityDidStart];
    });
}

- (void)operation:(KADOperation *)operation didProduceOperation:(NSOperation *)newOperation{
    
}

- (void)operationDidFinish:(KADOperation *)operation errors:(NSArray *)errors{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Decrement the network indicator's "reference count".
        [[NetworkIndicatorController sharedInstance] networkActivityDidEnd];
    });
}

@end

@interface NetworkIndicatorController()

@property (nonatomic) int activityCount;

@property (nonatomic, strong) Timer *visibilityTimer;

@end

@implementation NetworkIndicatorController

+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    static NetworkIndicatorController *_shared = nil;
    dispatch_once(&onceToken, ^{
        _shared = [[NetworkIndicatorController alloc] init];
    });
    
    return _shared;
}

- (id)init{
    if (self = [super init]) {
        _activityCount = 0;
    }
    
    return self;
}

- (void)networkActivityDidStart {
    NSAssert([NSThread isMainThread], @"Altering network activity indicator state can only be done on the main thread.");
    
    _activityCount++;
    
    [self updateIndicatorVisibility];
}

- (void)networkActivityDidEnd{
    NSAssert([NSThread isMainThread], @"Altering network activity indicator state can only be done on the main thread.");
    
    _activityCount--;
    
    [self updateIndicatorVisibility];
}

- (void)updateIndicatorVisibility{
    if (_activityCount > 0) {
        [self showIndicator];
    }
    else {
        /*
         To prevent the indicator from flickering on and off, we delay the
         hiding of the indicator by one second. This provides the chance
         to come in and invalidate the timer before it fires.
         */
        _visibilityTimer = [[Timer alloc] initWithInterval:1.0 handler:^{
            [self hideIndicator];
        }];
    }
}

- (void)showIndicator {
    if (_visibilityTimer != nil) {
        [_visibilityTimer cancel];
        _visibilityTimer = nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)hideIndicator{
    if (_visibilityTimer != nil) {
        [_visibilityTimer cancel];
        _visibilityTimer = nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

@end

@interface Timer()

@property (nonatomic) BOOL isCancelled;

@end

@implementation Timer

- (id)initWithInterval:(NSTimeInterval)interval handler:(dispatch_block_t)handler {
    if (self = [super init]) {
        self.isCancelled = false;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isCancelled == false) {
                handler();
            }
        });
    }
    
    return self;
}

- (void)cancel{
    self.isCancelled = true;
}

@end