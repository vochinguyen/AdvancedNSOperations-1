//
//  ViewController.m
//  AdvancedNSOperation
//
//  Created by Andrey K. on 01.07.15.
//  Copyright (c) 2015 Andrey K. All rights reserved.
//

#import "ViewController.h"
#import "KADOperationQueue.h"
#import "GetEarthquakesOperation.h"

@interface ViewController ()

@property (nonatomic, strong) KADOperationQueue *operationQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationQueue = [[KADOperationQueue alloc] init];
    
    GetEarthquakesOperation *getEarthquakesOperation = [[GetEarthquakesOperation alloc] initWithContext:nil completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"getEarthquakesOperation - completionHandler");
        });
    }];
    
    getEarthquakesOperation.userInitiated = YES;
    [_operationQueue addOperation:getEarthquakesOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
