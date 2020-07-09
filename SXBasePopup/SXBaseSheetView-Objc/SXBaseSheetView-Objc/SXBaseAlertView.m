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
@property(nonatomic, weak) UIView *m_firstResponder;

@end

@implementation SXBaseAlertView
+(instancetype)view {
    NSString *nibName = NSStringFromClass(self);
    NSArray *objs =
    [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options: nil];
      
    SXBaseAlertView *view;
    for (id obj in objs) {
        if ([obj isKindOfClass: self]) {
            view = obj;
            break;
        }
    }
    if (view) {
        return view;
    }
    return [self new];
}
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self baseSetupUI];
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self baseSetupUI];
    [self setupUI];
    [self registNotification];

}
#pragma mark - ui
- (void)baseSetupUI {
    self.layer.cornerRadius = 8.0f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];

}
- (void)setupUI {
    
}

#pragma mark - public

- (void)show
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keywindow.subviews.reverseObjectEnumerator) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
        }
    }
    [self removeAllDuplicateBg];
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
+(void)hide {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keywindow.subviews.reverseObjectEnumerator) {
        if ([view isKindOfClass:[self class]]) {
            SXBaseAlertView *sv = (SXBaseAlertView *)view;
            [sv hide];
        }
    }
}
- (void)hide
{
    [self animatedOut];
}

#pragma mark - private

- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self removeAllDuplicateBg];
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
    return [UIScreen mainScreen].bounds.size.width - 30;
    
}
- (CGFloat)showHeight {;
    return [UIScreen mainScreen].bounds.size.height - 200;
}
#pragma mark - 键盘处理
- (void)registNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)note{
    UIView *resView = nil;
    for (UIView *subV in self.subviews) {
        if ([subV isFirstResponder]) {
            resView = subV;
            break;
        }
    }
    if (!resView) {
        for (UIView *subV in self.subviews) {
            for (UIView *subbV in subV.subviews) {
                if ([subbV isFirstResponder]) {
                    resView = subbV;
                    break;
                }
            }
            if (resView) {
                break;
            }
        }
    }
    CGRect frame = resView.frame;
    if(![resView.superview isEqual: self]) {
        frame = [resView.superview convertRect:resView.frame toView:self];
    }
    self.m_firstResponder = resView;
    //获取键盘高度
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (CGRectGetMaxY(frame)+25 < kbSize.height) {
        return;
    }
    CGFloat y = [UIScreen mainScreen].bounds.size.height - (CGRectGetMaxY(frame)+kbSize.height+25);
    [UIView animateWithDuration:0.1 animations:^{
        self.frame =
        CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5,y, self.showWidth, self.showHeight);
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat offsetY = [UIScreen mainScreen].bounds.size.height - self.showHeight;
        
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5, offsetY, self.showWidth, self.showHeight);
    }];
}
/// 移除所有重复bg
- (void)removeAllDuplicateBg {
    NSArray<UIView *> *subs = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *sub in subs) {
        if (sub.tag == 2946) {
            [sub removeFromSuperview];
        }
    }
}

#pragma mark - getter and setter
- (UIControl *)controlForDismiss
{
    if (!_controlForDismiss) {
        _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        CGFloat alpha = 0.7;
        _controlForDismiss.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: alpha];
        _controlForDismiss.tag = 2946;
#if 1
        [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
#endif
    }
    return _controlForDismiss;
}
@end
