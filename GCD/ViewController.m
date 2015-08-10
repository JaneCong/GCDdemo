//
//  ViewController.m
//  GCD
//
//  Created by CoderLEE on 15/8/10.
//  Copyright (c) 2015年 CoderLEE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 定时器
-(void)timer
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 15ull*NSEC_PER_SEC, 1ull*NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"wake up");
        dispatch_source_cancel(timer);
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel");
    });
    // 启动
    dispatch_resume(timer);
}

-(void)downloadImage
{
    // 创建一个组
    dispatch_group_t group = dispatch_group_create();
    // 下载图片1
    __block UIImage *image1 = nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image1 = [self downloadImageWithUrl:@"https://www.baidu.com/img/bdlogo.png"];
    });
    // 下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image2 = [self downloadImageWithUrl:@"http://img1.bdstatic.com/static/home/widget/search_box_home/logo/home_white_logo_0ddf152.png"];
    });
    // group任务都执行完毕，再执行其他操作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 合并图片
        UIGraphicsBeginImageContext(CGSizeMake(300, 300));
        [image1 drawInRect:CGRectMake(0, 0, 150, 300)];
        [image2 drawInRect:CGRectMake(150, 0, 150, 300)];
        UIGraphicsEndImageContext();
    });
}
-(UIImage *)downloadImageWithUrl:(NSString *)urlStr
{

    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

#pragma mark 同步+串行
-(void)syncSerialQueue
{

    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("gcd.queue", NULL);
    // 2.添加任务到队列中执行任务
    dispatch_sync(queue, ^{
        NSLog(@"下载1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载3----%@",[NSThread currentThread]);
    });
}

#pragma mark 同步+并发
-(void)syncConcurrentQueue
{
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.添加任务到队列中执行任务
    dispatch_sync(queue, ^{
        NSLog(@"下载1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载3----%@",[NSThread currentThread]);
    });
}

#pragma mark 异步+串行
-(void)asyncSerialQueue
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("gcd.queue", NULL);
    // 2.添加任务到队列中执行任务
    dispatch_async(queue, ^{
        NSLog(@"下载1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载3----%@",[NSThread currentThread]);
    });
}

#pragma mark 异步＋并行
-(void)asyncConcurrentQueue
{
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.添加任务到队列中执行任务
    dispatch_async(queue, ^{
        NSLog(@"下载1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载3----%@",[NSThread currentThread]);
    });
}
@end
