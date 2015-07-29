//
//  BCMoreView.h
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCMoreViewDelegate <NSObject>

- (void)didselectImageView:(NSInteger)index;

@end

@interface BCMoreView : UIView
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,weak)id <BCMoreViewDelegate> delegate;
@end
