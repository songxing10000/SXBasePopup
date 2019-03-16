//
//  ViewController.m
//  SXBaseAlertSheetVC-Objc
//
//  Created by dfpo on 2019/3/16.
//  Copyright © 2019 dfpo. All rights reserved.
//

#import "ViewController.h"
#import "CodeVC.h"
#import "XibVC.h"
@interface ViewController ()
@property(nonatomic, assign) VCShowType type;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type =  VCShowTypeAlert;
}
- (IBAction)segValueChanged:(UISegmentedControl *)sender {
    self.type = sender.selectedSegmentIndex == 0 ? VCShowTypeAlert : VCShowTypeSheet;
}
- (IBAction)clickCodeBtn:(UIButton *)sender {
    CodeVC *vc = [CodeVC vc];
    [vc showInVC:self type:self.type];
}
- (IBAction)clickXi4bBtn:(UIButton *)sender {
    XibVC *vc = [XibVC vc];
    [vc showInVC:self type:self.type];
}

@end
