//
//  SXBaseAlertView.m
//  SXBaseSheetView
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SXBaseSheetView.h"

@interface SXBaseSheetView()
@property (nonatomic) UIControl *bgControl;
@property(nonatomic, weak) UIView *m_firstResponder;
@end

@implementation SXBaseSheetView
+(instancetype)view {
    NSString *nibName = NSStringFromClass(self);
    NSArray *objs =
    [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options: nil];
    
    SXBaseSheetView *view;
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
        [self setupUI];
        [self registNotification];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    [self registNotification];

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
    [self removeAllDuplicateBg];

    if (self.bgControl)
    {
        [keywindow addSubview:self.bgControl];
        
    }
    
    [keywindow addSubview:self];
    
    
    [self setAllViewAlpha:0];
    CGFloat offsetYb = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5,offsetYb, self.showWidth, self.showHeight);
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self setAllViewAlpha:1];
        CGFloat offsetY = [UIScreen mainScreen].bounds.size.height - self.showHeight;

        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5, offsetY, self.showWidth, self.showHeight);
        
    } completion:NULL];
    
    
}
+ (void)hide {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    //点击后删除之前的
    for (UIView *view in keywindow.subviews.reverseObjectEnumerator) {
        if ([view isKindOfClass:[self class]]) {
            SXBaseSheetView *sv = (SXBaseSheetView *)view;
            [sv hide];
        }
    }
}

- (void)hide
{
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        
        [self setAllViewAlpha:0];
        CGFloat offsetY = [UIScreen mainScreen].bounds.size.height;
        self.frame =
        CGRectMake(([UIScreen mainScreen].bounds.size.width - self.showWidth)*0.5,offsetY, self.showWidth, self.showHeight);
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            if (self.bgControl)
            {
                [self removeAllDuplicateBg];
                [self.bgControl removeFromSuperview];
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
    self.bgControl.alpha = alpha;
}

#pragma mark - 子类没有实现时，提供一个默认的大小
- (CGFloat)showWidth {
    return [UIScreen mainScreen].bounds.size.width;
    
}
- (CGFloat)showHeight {
    return [UIScreen mainScreen].bounds.size.height - 200;
}
- (void)tapBg {
    UIView *resV = self.m_firstResponder;
    if (resV && [resV isFirstResponder]) {
        [resV resignFirstResponder];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 上圆角
//    [self addTopLeftAndTopRightCorner:8];
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
    CGFloat y = [UIScreen mainScreen].bounds.size.height - (CGRectGetMaxY(frame)+kbSize.height+10);
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
#pragma mark - 上圆角
//- (void)addTopLeftAndTopRightCorner:(CGFloat)corner {
//    if (self.layer.mask != nil) {
//        return;
//    }
//    // 仅上方圆角
//    CGRect f = self.bounds;
//    if (self.ok_heightConstraint.constant) {
//        f.size.height = MAX(f.size.height, self.ok_heightConstraint.constant);
//    }
//    if (self.ok_widthConstraint.constant) {
//        f.size.width = MAX(f.size.width, self.ok_widthConstraint.constant);
//    }
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:f byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(corner, corner)];
//    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
//    layer.frame = f;
//    layer.path = path.CGPath;
//    self.layer.mask = layer;
//}
/// 移除所有重复bg
- (void)removeAllDuplicateBg {
    NSArray<UIView *> *subs = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *sub in subs) {
        if (sub.tag == 2942) {
            [sub removeFromSuperview];
        }
    }
}
#pragma mark - getter and setter
- (UIControl *)bgControl
{
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_bgControl addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        _bgControl.tag = 2942;

    }
    return _bgControl;
}
@end
