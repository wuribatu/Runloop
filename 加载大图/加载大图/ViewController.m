//
//  ViewController.m
//  加载高清大图
//
//  Created by Batu on 17/1/12.
//  Copyright © 2017年 H. All rights reserved.
//

#import "ViewController.h"

/*
 1. 首先将加载图片的任务保存起来！不直接执行，用一个数组保存起来
 2. 监听RunLoop循环！
 3. 每次RunLoop循环就让它取出一个加载图片的任务出来执行！
 */

typedef BOOL(^RunloopBlock)(void);

static NSString *IDENTIFIER = @"IDENTIFIER";

static CGFloat CELL_HEIGHT = 135.f;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSMutableArray *tasksKeys;
@property (nonatomic, assign) NSUInteger max;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITableView *exampleTableView;

@end

@implementation ViewController

- (void)_timerFiredMethod{}

- (void)viewDidLoad {
    [super viewDidLoad];
    _max = 18;
    _tasks = [NSMutableArray array];
    _tasksKeys = [NSMutableArray array];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_timerFiredMethod) userInfo:nil repeats:YES];
    
    [self.exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
    [self addRunloopObserver];
}

+(void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label1.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.tag = 5;
    [cell.contentView addSubview:label1];
    
}

+ (void)addImage1With:(UITableViewCell *)cell {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 1;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}

+ (void)addImage2With:(UITableViewCell *)cell {
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView1.tag = 2;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image1;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView1];
    } completion:nil];
}

+ (void)addImage3With:(UITableViewCell *)cell{
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView2.tag = 3;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image2;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView2];
    } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.exampleTableView.frame = self.view.bounds;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)loadView {
    self.view = [UIView new];
    self.exampleTableView = [UITableView new];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:self.exampleTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 399;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (NSInteger i = 1; i <= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    
    [ViewController addlabel:cell indexPath:indexPath];

    [self addTask:^BOOL{
        [ViewController addImage1With:cell];
        return YES;
    } withKey:indexPath];
    [self addTask:^BOOL{
        [ViewController addImage2With:cell];
        return YES;
    } withKey:indexPath];
    [self addTask:^BOOL{
        [ViewController addImage3With:cell];
        return YES;
    } withKey:indexPath];

    return cell;
}

- (void)addTask:(RunloopBlock)unit withKey:(id)key {
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.max) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    ViewController * vc = (__bridge ViewController *)(info);
    if (vc.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && vc.tasks.count) {
        RunloopBlock unit = vc.tasks.firstObject;
        result = unit();
        [vc.tasks removeObjectAtIndex:0];
        [vc.tasksKeys removeObjectAtIndex:0];
    }
}

- (void)addRunloopObserver {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        ( __bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    static CFRunLoopObserverRef defaultModeObsever;
    defaultModeObsever = CFRunLoopObserverCreate(NULL,
                                                 kCFRunLoopBeforeWaiting,
                                                 YES,
                                                 NSIntegerMax - 999,
                                                 &Callback,
                                                 &context
                                                 );
    
    CFRunLoopAddObserver(runloop, defaultModeObsever, kCFRunLoopDefaultMode);
    CFRelease(defaultModeObsever);
}

@end
