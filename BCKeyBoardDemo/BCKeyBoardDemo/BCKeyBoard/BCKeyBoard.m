//
//  BCKeyBoard.m
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import "BCKeyBoard.h"
#import "BCTextView.h"
#import "Const.h"
#import "DXFaceView.h"
#import "BCMoreView.h"

@interface BCKeyBoard () <UITextViewDelegate,DXFaceDelegate,BCMoreViewDelegate>
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIButton *faceBtn;
@property (nonatomic,strong)UIButton *moreBtn;
@property (nonatomic,strong)BCTextView  *textView;
@property (nonatomic,strong)UIView *faceView;
@property (nonatomic,assign)BOOL isTop;
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,assign)CGFloat lastHeight;
//拓展的view
@property (nonatomic,strong)UIView *activeView;
@end

@implementation BCKeyBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    [super setFrame:frame];
}
- (void)createUI
{
    _lastHeight = 30;
    //注册键盘改变是调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    
    
    //表情按钮
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBtn.frame = CGRectMake(kHorizontalPadding,kHorizontalPadding, 30, 30);
    [self.faceBtn addTarget:self action:@selector(willShowFaceView:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self addSubview:self.faceBtn];
    
    //文本
    self.textView = [[BCTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.faceBtn.frame)+kHorizontalPadding, kHorizontalPadding, self.bounds.size.width - 4*kHorizontalPadding - 30*2, 30)];
    self.textView.placeholderColor = self.placeholderColor;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = 0.65f;
    self.textView.layer.cornerRadius = 6.0f;
    self.textView.delegate = self;
    
    //更多按钮
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+kHorizontalPadding,kHorizontalPadding,30,30);
    [self.moreBtn addTarget:self action:@selector(willShowactiveView:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.textView];
    [self.backgroundImageView addSubview:self.faceBtn];
    [self.backgroundImageView addSubview:self.moreBtn];
    
    if (!self.faceView) {
        self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        [(DXFaceView *)self.faceView setDelegate:self];
        self.faceView.backgroundColor = [UIColor whiteColor];
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.moreView) {
        self.moreView = [[BCMoreView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        self.moreView.backgroundColor = [UIColor whiteColor];
        [(BCMoreView *)self.moreView setDelegate:self];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}
- (void)changeFrame:(CGFloat)height{
    
    if (height == _lastHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = height - _lastHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.backgroundImageView.frame;
        rect.size.height += changeHeight;
        self.backgroundImageView.frame = rect;
        
        
        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        
        CGRect frame = self.textView.frame;
        frame.size.height = height;
        self.textView.frame = frame;
        
        _lastHeight = height;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
            [self.delegate returnHeight:height];
        }
    }

}
- (void)setPlaceholder:(NSString *)placeholder
{
    self.textView.placeholder = placeholder;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.textView.placeholderColor = placeholderColor;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        CGRect frame = self.frame;
        frame.origin.y = endFrame.origin.y - self.bounds.size.height;
        self.frame = frame;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}
#pragma mark 表情View
- (void)willShowFaceView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.faceView];
        [self.textView resignFirstResponder];
    }else{
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark 表更多View
- (void)willShowactiveView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.moreView];
        [self.textView resignFirstResponder];
        [(BCMoreView *)self.moreView setImageArray:self.imageArray];
    }else{
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.backgroundImageView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    self.frame = toFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
        [self.delegate returnHeight:toHeight];
    }
}
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self willShowBottomView:nil];
    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
}
- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = nil;
    }
    else if(toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.textView.text = @"";
            [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
        }
        return NO;
    }
    return YES;
}
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activeView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.backgroundImageView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = bottomView;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                self.textView.text = [chatText substringToIndex:chatText.length-2];
                [self textViewDidChange:self.textView];
                return;
            }
        }
        if (chatText.length > 0) {
            self.textView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    [self textViewDidChange:self.textView];
}
- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.textView.text = @"";
            [self changeFrame:ceilf([self.textView sizeThatFits:self.textView.frame.size].height)];
        }
    }
}
- (void)didselectImageView:(NSInteger)index
{
    //这里是更多的view中选择了哪个图片
    NSLog(@"%ld",(long)index);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
