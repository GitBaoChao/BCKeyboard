//
//  BCKeyBoard.h
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCKeyBoardDelegate <NSObject>

/**
 发送的文字
 */
- (void)didSendText:(NSString *)text;

/**
 回调返回高度
 */
- (void)returnHeight:(CGFloat)height;


@end

@interface BCKeyBoard : UIView

@property (nonatomic,weak)id <BCKeyBoardDelegate> delegate;
@property (nonatomic,strong)NSArray *imageArray; /**< 点击加号弹出的View中的图片数组 */
@property (nonatomic,strong)NSString *placeholder; /**< 占位文字 */
@property (nonatomic,strong)UIColor *placeholderColor; /**< 占位文字颜色 */

@end
