//
//  SXBaseAlertView.h
//  SXBaseAlertView
//
//  Created by dfpo on 2016/12/22.
//  Copyright © 2016年 dfpo. All rights reserved.
//

@import UIKit;

/// 从屏幕中央弹出的视图，类似系统的alert
@interface SXBaseAlertView : UIView

#pragma mark - 子类需要实现的方法
/// 展现时的宽度
- (CGFloat)showWidth;
/// 展现时的高度
- (CGFloat)showHeight;

#pragma mark - 父类提供的展示方法
/// 显示
- (void)show;
/// 隐藏
- (void)hide;
/// 隐藏
- (void)dismiss;

@end
