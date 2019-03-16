//
//  CodeVC.swift
//  SXBaseAlertSheetVC-Swift
//
//  Created by dfpo on 2019/3/16.
//  Copyright © 2019 dfpo. All rights reserved.
//

import UIKit

class CodeVC: SXBaseAlertSheetVC {
    class func vc() -> CodeVC {
        return CodeVC()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func showSize() -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    override func showHeight() -> CGFloat {
        return 200
    }
    override func showInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
