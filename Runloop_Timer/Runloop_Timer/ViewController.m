//
//  ViewController.m
//  Runloop_Timer
//
//  Created by Batu on 2017/2/26.
//  Copyright © 2017年 Batu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self timer];
//    [self asyncTimer];
//    [self observer];
}

- (void)timer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)asyncTimer {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    });
}

- (void)observer {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"----RunLoop activity-----%zd", activity);
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

- (void)run {
    NSLog(@"--run--");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
