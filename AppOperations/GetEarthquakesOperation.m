//
//  GetEarthquakesOperation.m
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "GetEarthquakesOperation.h"
#import "DownloadEarthquakesOperation.h"
#import <CoreData/CoreData.h>

@interface GetEarthquakesOperation()

@property (nonatomic, strong) DownloadEarthquakesOperation *downloadOperation;

@end

@implementation GetEarthquakesOperation

- (instancetype)initWithContext:(NSManagedObjectContext *)context completionHandler:(void(^)())completionHandler{
    NSURL *cachesFolder = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil];
    
    NSURL *cacheFile = [cachesFolder URLByAppendingPathComponent:@"earthquakes.json"];
    
    /*
     This operation is made of three child operations:
     1. The operation to download the JSON feed
     2. The operation to parse the JSON feed and insert the elements into the Core Data store
     3. The operation to invoke the completion handler
     */
    _downloadOperation = [[DownloadEarthquakesOperation alloc] initWithCacheFile:cacheFile];
//    parseOperation = ParseEarthquakesOperation(cacheFile: cacheFile, context: context)
    
    NSBlockOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:completionHandler];
    
    // These operations must be executed in order
//    NSBlockOperation *parseOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"parseOperation");
//    }];
//    [parseOperation addDependency:_downloadOperation];
    
    self = [super initWithOperations:@[_downloadOperation, finishOperation]];
    
    if (self) {
        self.name = @"Get Earthquakes";
    }
    
    return self;
}

- (void)operationDidFinish:(NSOperation *)operation withErrors:(NSArray *)errors{
//    if let firstError = errors.first where (operation === downloadOperation || operation === parseOperation) {
//        produceAlert(firstError)
//    }
}

//- (void)produceAlert:(NSError *)error {
//    /*
//     We only want to show the first error, since subsequent errors might
//     be caused by the first.
//     */
//    if hasProducedAlert { return }
//    
//    let alert = AlertOperation()
//    
//    let errorReason = (error.domain, error.code, error.userInfo[OperationConditionKey] as? String)
//    
//    // These are examples of errors for which we might choose to display an error to the user
//    let failedReachability = (OperationErrorDomain, OperationErrorCode.ConditionFailed, ReachabilityCondition.name)
//    
//    let failedJSON = (NSCocoaErrorDomain, NSPropertyListReadCorruptError, nil as String?)
//    
//    switch errorReason {
//    case failedReachability:
//        // We failed because the network isn't reachable.
//        let hostURL = error.userInfo[ReachabilityCondition.hostKey] as! NSURL
//        
//        alert.title = "Unable to Connect"
//        alert.message = "Cannot connect to \(hostURL.host!). Make sure your device is connected to the internet and try again."
//        
//    case failedJSON:
//        // We failed because the JSON was malformed.
//        alert.title = "Unable to Download"
//        alert.message = "Cannot download earthquake data. Try again later."
//        
//    default:
//        return
//    }
//    
//    produceOperation(alert)
//    hasProducedAlert = true
//}

@end
