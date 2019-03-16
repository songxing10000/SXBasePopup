//
//  SXBaseAlertView.m
//  SXBaseSheetView
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SXBaseSheetView.h"

@interface SXBaseSheetView()
@property (nonatomic) UIControl *controlForDismiss;
@property (nonatomic) BOOL needBottomNoMargin;
@end

@implementation SXBaseSheetView

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
    
    
    
}
- (void)show
{

    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    //点击后删除之前的
    for (UIView *view in keywindow.subviews.reverseObjectEnumerator) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.controlForDismiss)
    {
        [keywindow addSubview:self.controlForDismiss];
        
    }
    
    [keywindow addSubview:self];
    
    
    [self setAllViewAlpha:0];
    CGFloat offsetYb = self.needBottomNoMargin?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height+10;
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5,offsetYb, self.showWidth, self.showHeight);
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self setAllViewAlpha:1];
        CGFloat offsetY = self.needBottomNoMargin?[UIScreen mainScreen].bounds.size.height - self.showHeight:[UIScreen mainScreen].bounds.size.height - self.showHeight-10;

        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5, offsetY, self.showWidth, self.showHeight);
        
    } completion:NULL];
    
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        
        [self setAllViewAlpha:0];
        CGFloat offsetY = self.needBottomNoMargin?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height-10;
        self.frame =
        CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5,offsetY, self.showWidth, self.showHeight);
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
            
            for (UIView *subV in self.subviews) {
                subV.hidden = YES;
            }
        }
        
    }];
}
/**
 设置 0 、1 的alpha
 
 @param alpha <#alpha description#>
 */
- (void)setAllViewAlpha:(CGFloat)alpha {
    self.alpha = alpha;
    for (UIView *subV in self.subviews) {
        subV.alpha = alpha;
    }
    self.controlForDismiss.alpha = alpha;
}

#pragma mark - 子类没有实现时，提供一个默认的大小
- (CGFloat)showWidth {
    
//    SXLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
//    [self doesNotRecognizeSelector:_cmd];
    return [UIScreen mainScreen].bounds.size.width;
    
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
        _controlForDismiss.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_controlForDismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlForDismiss;
}
@end
