//
//  ViewController.swift
//  SXBaseAlertSheetVC-Swift
//
//  Created by dfpo on 2019/3/16.
//  Copyright © 2019 dfpo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var  type: VCShowType = .alert
    
    @IBAction func segValueChanged(_ sender: UISegmentedControl) {
        type = (sender.selectedSegmentIndex == 0) ? .alert : .sheet
    }
    @IBAction func clickCodeBtn(_ sender: UIButton) {
        let vc = CodeVC.vc()
        vc.showInVC(desVC: self, type: type)
    }
    @IBAction func clickXibBtn(_ sender: UIButton) {
        let vc = XibVC.vc()
        vc.showInVC(desVC: self, type: type)
    }
    
    
}

