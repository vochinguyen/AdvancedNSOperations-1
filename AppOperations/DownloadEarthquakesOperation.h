//
//  DownloadEarthquakesOperation.h
//  AdvancedNSOperation
//
//  Created by Chi Nguyen Vo on 8/24/15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "KADGroupOperation.h"

@interface DownloadEarthquakesOperation : KADGroupOperation

- (id)initWithCacheFile:(NSURL *)cacheFile;

@end
