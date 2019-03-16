//
//  SXBaseAlertView.m
//  SXBaseAlertView
//
//  Created by dfpo on 2016/12/22.
//  Copyright © 2016年 dfpo. All rights reserved.
//


#import "SXBaseAlertView.h"
@interface SXBaseAlertView()
#pragma mark - 特别情况下调用，方便CKKSignOutView重写父类动画
@property (nonatomic) UIControl *controlForDismiss;
@end

@implementation SXBaseAlertView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}
#pragma mark - ui
- (void)setupUI {
    
    self.layer.borderColor =
    [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6.0f;
    self.clipsToBounds = YES;
    
}

#pragma mark - public

- (void)show
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlForDismiss)
    {
        [keywindow addSubview:self.controlForDismiss];
        
    }
    [keywindow addSubview:self];
    self.frame = CGRectMake(0, 0, self.showWidth, self.showHeight);
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    
    [self animatedIn];
}
- (void)hide
{
    [self dismiss];
}
- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - private

- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - action
- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
    [[UIApplication sharedApplication].keyWindow endEditing:YES]; 
}

#pragma mark - 子类没有实现时，提供一个默认的大小
- (CGFloat)showWidth {
    
//    SXLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
//    [self doesNotRecognizeSelector:_cmd];
    return [UIScreen mainScreen].bounds.size.width - 30;
    
}
- (CGFloat)showHeight {
    
//    SXLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
//    [self doesNotRecognizeSelector:_cmd];
    return [UIScreen mainScreen].bounds.size.height - 200;
}
#pragma mark - getter and setter
- (UIControl *)controlForDismiss
{
    if (!_controlForDismiss) {
        _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _controlForDismiss.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
#if 1
        [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
#endif
    }
    return _controlForDismiss;
}
@end
