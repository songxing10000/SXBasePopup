//
//  SXBaseAlertSheetVC.h
//  SXBaseAlertSheetVC
//
//  Created by dfpo on 2016/12/22.
//  Copyright © 2016年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
/// VCShowType
typedef NS_ENUM(NSInteger, VCShowType)
{
    VCShowTypeAlert = 1,//!< alert
    VCShowTypeSheet,//!< sheet
};
/// alert、sheet弹窗基类
@interface SXBaseAlertSheetVC:UIViewController

/// 显示
- (void)showInVC:(UIViewController *)desVC type:(VCShowType)showType;
/// 隐藏
- (void)hide;
#pragma mark - sheet override
/// sheet override
- (CGFloat)showHeigth;
#pragma mark - alert override
/// alert override
- (CGSize)showSize;

/// alert模式下，设置了showInsets，会覆盖showSize
- (UIEdgeInsets)showInsets;
@end

