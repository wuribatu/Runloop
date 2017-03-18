//
//  ViewController.m
//  Runloop常驻线程
//
//  Created by Batu on 2017/3/9.
//  Copyright © 2017年 Batu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread *thread;

@end

@implementation ViewController
- (IBAction)create:(id)sender {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [thread start];
    [thread setName:@"com.test.thread"];
    self.thread = thread;
}

- (IBAction)goOn:(id)sender {
    [self performSelector:@selector(task2) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)task1 {
    NSLog(@"task1 ----%@", [NSThread currentThread]);
}

- (void)task2 {
    NSLog(@"task2----%@",[NSThread currentThread]);
}

- (void)run {
    NSLog(@"--run--");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
