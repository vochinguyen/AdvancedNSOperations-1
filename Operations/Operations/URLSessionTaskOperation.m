//
//  URLSessionTaskOperation.m
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "URLSessionTaskOperation.h"

static void *URLSessionTaksOperationKVOContext = 0;

@interface URLSessionTaskOperation()

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation URLSessionTaskOperation

- (id)initWithTask:(NSURLSessionTask *)task {
    NSAssert(task.state == NSURLSessionTaskStateSuspended, @"Tasks must be suspended.");
    
    if (self = [super init]) {
        self.task = task;
    }
    
    return self;
}

- (void)execute{
    NSAssert(self.task.state == NSURLSessionTaskStateSuspended, @"Task was resumed by something other than \(self).");
    
    [self.task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld context:&URLSessionTaksOperationKVOContext];
    
    [self.task resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context != &URLSessionTaksOperationKVOContext){
        return;
    }

    if ([self.task isEqual:object] && [keyPath isEqualToString:@"state"] && self.task.state ==  NSURLSessionTaskStateCompleted){
        [self.task removeObserver:self forKeyPath:@"state"];
        [self finish];
    }
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
