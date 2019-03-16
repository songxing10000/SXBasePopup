//
//  SXBaseAlertView.h
//  SXBaseSheetView
//
//  Created by mac on 2016/12/17.
//  Copyright © 2016年 mac. All rights reserved.
//
@import UIKit;

/// 从屏幕中央弹出的视图，类似系统的sheet
@interface SXBaseSheetView : UIView

#pragma mark - 子类需要实现的方法

/// 展现时的宽度
- (CGFloat)showWidth;
/// 展现时的高度
- (CGFloat)showHeight;

#pragma mark - 父类提供的展示方法

/// 显示
- (void)show;
/// 隐藏
- (void)dismiss;


@end
