//
//  DownloadEarthquakesOperation.m
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "DownloadEarthquakesOperation.h"
#import "URLSessionTaskOperation.h"
#import "KADReachabilityCondition.h"
#import "NetworkObserver.h"

@interface DownloadEarthquakesOperation()

@property (nonatomic, strong) NSURL *cacheFile;

@end

@implementation DownloadEarthquakesOperation

- (id)initWithCacheFile:(NSURL *)cacheFile{
    if (self = [super initWithOperations:@[]]) {
        self.cacheFile = cacheFile;
        self.name = @"Download Earthquakes";
        
        /*
         Since this server is out of our control and does not offer a secure
         communication channel, we'll use the http version of the URL and have
         added "earthquake.usgs.gov" to the "NSExceptionDomains" value in the
         app's Info.plist file. When you communicate with your own servers,
         or when the services you use offer secure communication options, you
         should always prefer to use https.
         */
        NSURL *url = [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            [self downloadFinishedWithURL:url response:(NSHTTPURLResponse *)response error:error];
        }];
        
        URLSessionTaskOperation *taskOperation = [[URLSessionTaskOperation alloc] initWithTask:task];
        
        KADReachabilityCondition *reachabilityCondition = [[KADReachabilityCondition alloc] initWithHost:url];
        [taskOperation addCondition:reachabilityCondition];
        
        NetworkObserver *networkObserver = [[NetworkObserver alloc] init];
        [taskOperation addObserver:networkObserver];
        
        [self addOperation:taskOperation];
    }
    
    return self;
}

- (void)downloadFinishedWithURL:(NSURL *)url response:(NSHTTPURLResponse *)response error:(NSError *)error {
    NSURL *localURL = url;
    if (localURL) {
        /*
         If we already have a file at this location, just delete it.
         Also, swallow the error, because we don't really care about it.
         */
        NSError *removeError;
        [[NSFileManager defaultManager] removeItemAtURL:self.cacheFile error:&removeError];
        if (removeError != nil) {
            [self aggregateError:removeError];
        }
        [[NSFileManager defaultManager] moveItemAtURL:localURL toURL:self.cacheFile error:&removeError];
        if (removeError != nil) {
            [self aggregateError:removeError];
        }
    }else if (error) {
        [self aggregateError:error];
    }else {
        // Do nothing, and the operation will automatically finish.
    }
}

@end
