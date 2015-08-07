//
//  ViewController.m
//  BCKeyBoardDemo
//
//  Created by baochao on 15/7/29.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import "ViewController.h"
#import "BCKeyBoard.h"
@interface ViewController () <BCKeyBoardDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png"];
    BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46, [UIScreen mainScreen].bounds.size.width,46)];
    bc.delegate = self;
    bc.imageArray = array;
    bc.placeholder = @"我来说几句";
    bc.currentCtr = self;
    bc.placeholderColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:0.5];
    bc.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bc];
}
- (void)didSendText:(NSString *)text
{
    NSLog(@"%@",text);
}
- (void)returnHeight:(CGFloat)height
{
    NSLog(@"%f",height);
}
- (void)returnImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = image;
    [self.view addSubview:imageView];
}
@end
