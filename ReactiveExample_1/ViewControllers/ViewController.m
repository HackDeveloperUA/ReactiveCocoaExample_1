//
//  ViewController.m
//  ReactiveExample_1
//
//  Created by Uber on 22/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (nonatomic, strong) NSString* username;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [RACObserve(self, username) subscribeNext:^(NSString *newName) {
        NSLog(@"%@", newName);
    }];
}




@end
