//
//  SXBaseAlertSheetVC.swift
//  SXBaseAlertSheetVC
//
//  Created by mac on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
/// VCShowType
enum VCShowType {
    case alert
    case sheet
}
/// alert、sheet弹窗基类
class SXBaseAlertSheetVC: UIViewController {
    var showType: VCShowType = .alert
    /// alert 模式下 需要一个显示的size
    public func showSize() -> CGSize {
        // 水平方向上的左右间距
        let hMargin: CGFloat = 15
        // 竖直方向上的上下间距
        let vMargin: CGFloat = 80
        let screenW: CGFloat = UIScreen.main.bounds.width
        let screenH: CGFloat = UIScreen.main.bounds.height
        return CGSize(width: screenW - 2 * hMargin, height: screenH - 2 * vMargin)
    }
    /// alert 模式下 需要一个显示的height 或者 showInset调整 下左右的间距
    public func showHeight() -> CGFloat {
        return 300
    }
    /// alert 模式下 需要一个显示的height 或者 showInset调整 下左右的间距
    public func showInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    // MARK: - 外部调用方法
    func showInVC(desVC: UIViewController, type showType: VCShowType) {
        self.showType = showType
        if showType == .sheet {
            let presentationC = SheetPresentationController(presentedViewController: self, presenting: desVC)
            presentationC.showInsets = self.showInsets()
            presentationC.showHeight = self.showHeight()
            self.transitioningDelegate = presentationC
            desVC.present(self, animated: true, completion: nil)
        } else if showType == .alert {
            let presentationC = AlertPresentationController(presentedViewController: self, presenting: desVC)
            presentationC.showInsets = self.showInsets()
            presentationC.showSize = self.showSize()
            self.transitioningDelegate = presentationC
            desVC.present(self, animated: true, completion: nil)
        }
    }
    public func hide() {
        dismiss(animated: true, completion: nil)
    }
}

fileprivate class SheetPresentationController: UIPresentationController {
    var showHeight: CGFloat = 0.0
    var showInsets: UIEdgeInsets = .zero
    ///  黑色半透明背景
    lazy var dimmingView: UIView? = {
        let dimmingView = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
        dimmingView.backgroundColor = .black
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tap)
        return dimmingView
    }()
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = UIModalPresentationStyle.custom
    }
    @objc func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
extension SheetPresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    override func presentationTransitionWillBegin() {
        if let dimmingView = self.dimmingView {
            containerView?.addSubview(dimmingView)
        }
        self.dimmingView?.alpha = 0
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView?.alpha = 0.4
            }, completion: nil)
        }
    }
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView = nil
        }
    }
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView?.alpha = 0
            }, completion: nil)
        }
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
            dimmingView = nil
        }
    }
    override var frameOfPresentedViewInContainerView: CGRect {
        let height: CGFloat = (showHeight > 0) ? showHeight : 300
        let leftM = (showInsets.left > 0) ? self.showInsets.left : 0
        let rightM = (showInsets.right > 0) ? showInsets.right : 0
        let bottomM = (showInsets.bottom > 0) ? showInsets.bottom : 0
        var containerViewBounds = self.containerView?.bounds ?? CGRect.zero
        containerViewBounds.origin.y = containerViewBounds.size.height - height - bottomM
        containerViewBounds.origin.x = leftM
        containerViewBounds.size.width = containerViewBounds.size.width - leftM - rightM
        containerViewBounds.size.height = height
        return containerViewBounds
    }
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container.isEqual(presentedViewController) {
            containerView?.setNeedsLayout()
        }
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? CGRect.zero
    }
}
fileprivate class AlertPresentationController: UIPresentationController {
    var showSize: CGSize = CGSize.zero
    var showInsets: UIEdgeInsets = UIEdgeInsets.zero
    ///  黑色半透明背景
    lazy var dimmingView: UIView? = {
        let dimmingView = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
        dimmingView.backgroundColor = .black
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tap = UITapGestureRecognizer(target:self, action:#selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tap)
        return dimmingView
    }()
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = UIModalPresentationStyle.custom
    }
    @objc func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UIViewControllerAnimatedTransitioning
extension AlertPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? true) ? 0.25 : 0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
            else {
                return
        }
        let isPresenting = (fromViewController == self.presentingViewController)
        if isPresenting {
            let containerView = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
            }
            containerView.addSubview(toView)
            let screenW = containerView.bounds.width
            let screenH = containerView.bounds.height
            let isUseSize = (showSize.width > 0 && showSize.height > 0)
            var h: CGFloat, w: CGFloat, y: CGFloat, x: CGFloat
            if isUseSize {
                h = self.showSize.height > screenH ? screenH : showSize.height
                w = self.showSize.width > screenW ? screenW : showSize.width
                y = (screenH - h) * 0.5
                x = (screenW - w) * 0.5
            } else {
                x = self.showInsets.top
                if x < 0 {
                    x = 0
                }
                y = self.showInsets.left
                if y < 0 {
                    y = 0
                }
                var right = self.showInsets.right
                if right < 0 {
                    right = 0
                }
                var bottom = self.showInsets.bottom
                if bottom < 0 {
                    bottom = 0
                }
                w = screenW - x - right
                h = screenH - y - bottom
            }
            toView.frame = CGRect(x: x, y: y, width: w, height: h)
            toView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            toView.alpha = 0
        }
        UIView.animate(withDuration: 0.25, animations: {
            if isPresenting {
                let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
                toView?.alpha = 1
                toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            } else {
                let fromView = transitionContext.view(forKey: .from)
                fromView?.alpha = 0
            }
        }, completion: { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition( !wasCancelled)
        })
    }
    func animationEnded(_ transitionCompleted: Bool) {}
}
// MARK: - UIViewControllerTransitioningDelegate
extension AlertPresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    override func presentationTransitionWillBegin() {
        if let dimmingView = self.dimmingView {
            containerView?.addSubview(dimmingView)
        }
        self.dimmingView?.alpha = 0
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView?.alpha = 0.4
            }, completion: nil)
        }
    }
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView = nil
        }
    }
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView?.alpha = 0
            }, completion: nil)
        }
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
            dimmingView = nil
        }
    }
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container.isEqual(presentedViewController) {
            return container.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = containerView?.bounds ?? CGRect.zero
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        var presentedViewControllerFrame = containerViewBounds
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
        return presentedViewControllerFrame
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? CGRect.zero
    }
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container.isEqual(presentedViewController) {
            containerView?.setNeedsLayout()
        }
    }
}
