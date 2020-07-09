//
//  SXBaseSheetView.swift
//  SXBaseAlertSheetVC
//
//  Created by mac on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//
import UIKit

/// 从屏幕中央弹出的视图，类似系统的sheet
class SXBaseSheetView: UIView {
    // MARK: - 子类需要实现的方法
    /// 展现时的宽度
    public func showWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    /// 展现时的高度
    public func showHeight() -> CGFloat {
        return UIScreen.main.bounds.height - 200
    }
    // MARK: - 父类提供的展示方法
    /// 显示
    @objc public func show() {
        guard let  keyWin = UIApplication.shared.keyWindow else {
            return
        }
        for (_, keyWinSubV)  in keyWin.subviews.enumerated().reversed() {
            if keyWinSubV is  SXBaseSheetView {
                keyWinSubV.removeFromSuperview()
            }
        }
        if let _ = controlForDismiss.superview {} else {
            keyWin.addSubview(controlForDismiss)
        }
        keyWin.addSubview(self)
        setAllViewAlpha(alpha: 0)
        let screenH = UIScreen.main.bounds.height
        let screenW = UIScreen.main.bounds.width
        let x = (screenW - showWidth()) * 0.5
        let y = needBottomNoMargin ? screenH : screenH + 10
        frame = CGRect(x: x, y: y, width: showWidth(), height: showHeight())
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            self.setAllViewAlpha(alpha: 1)
            let showY = (self.needBottomNoMargin ? (screenH - self.showHeight()) : (screenH - self.showHeight()))
            self.frame = CGRect(x: x, y: showY, width: self.showWidth(), height: self.showHeight())
        }) { (finished) in
        }
    }
    lazy private var controlForDismiss: UIControl = {
        let control = UIControl(frame: UIScreen.main.bounds)
        control.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        control.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return control
    }()
    private var needBottomNoMargin: Bool {
        return false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    private func setUI() {}
    func setAllViewAlpha(alpha: CGFloat) {
        self.alpha = alpha
        for subV in subviews {
            subV.alpha = alpha
        }
        controlForDismiss.alpha = alpha
    }
    /// 隐藏
    @objc func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            self.setAllViewAlpha(alpha: 0)
            let screenH = UIScreen.main.bounds.height
            let screenW = UIScreen.main.bounds.width
            let x = (screenW - self.showWidth()) * 0.5
            let y: CGFloat = (self.needBottomNoMargin ? screenH : (screenH - 10))
            self.frame = CGRect(x: x, y: y, width: self.showWidth(), height: self.showHeight())
        }) { (finished) in
            if finished {
                if self.controlForDismiss.superview != nil {
                    self.controlForDismiss.removeFromSuperview()
                }
                self.removeFromSuperview()
                for subV in self.subviews {
//                    subV.isHidden = true
                }
            }
        }
    }
}
