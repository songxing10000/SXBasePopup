//
//  SXBaseAlertSheetVC.h
//  SXBaseAlertSheetVC
//
//  Created by dfpo on 2016/12/22.
//  Copyright © 2016年 dfpo. All rights reserved.
//
#import "SXBaseAlertSheetVC.h"

@interface SheetPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>
@property(nonatomic, assign) CGFloat showHeigth;
@property(nonatomic, assign) UIEdgeInsets showInsets;
@end
@interface AlertPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>
@property(nonatomic, assign) CGSize showSize;
@property(nonatomic, assign) UIEdgeInsets showInsets;
@end
@interface SXBaseAlertSheetVC()
@property(nonatomic, assign) VCShowType showType;
@end
@implementation SXBaseAlertSheetVC
- (CGFloat)showHeigth {
    return 300;
}
- (UIEdgeInsets)showInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)showSize {
    // 水平方向上的左右间距
    CGFloat hMargin = 15;
    // 竖直方向上的上下间距
    CGFloat vMargin = 80;
    CGFloat devW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat devH = CGRectGetHeight([UIScreen mainScreen].bounds);

    return CGSizeMake(devW-2*hMargin, devH-2*vMargin);
}
- (void)showInVC:(UIViewController *)desVC type:(VCShowType)showType {
    
    self.showType = showType;
    if (self.showType == VCShowTypeSheet) {
        SheetPresentationController *presentationC = [[SheetPresentationController alloc] initWithPresentedViewController:self presentingViewController:desVC];
        presentationC.showInsets = self.showInsets;
        presentationC.showHeigth  = self.showHeigth;
        self.transitioningDelegate = presentationC ;
        [desVC presentViewController:self animated:YES completion:nil];

    } else if (self.showType == VCShowTypeAlert) {
        AlertPresentationController *presentationC = [[AlertPresentationController alloc] initWithPresentedViewController:self presentingViewController:desVC];
        presentationC.showInsets = self.showInsets;
        presentationC.showSize  = self.showSize;
        self.transitioningDelegate = presentationC ;
        [desVC presentViewController:self animated:YES completion:nil];
    }
}
- (void)hide {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 这里可加圆角如 self.view.layer.cornerRadius = 7.5;

}
@end

@interface SheetPresentationController ()
/** 黑色半透明背景 */
@property (nonatomic, strong) UIView *dimmingView;
@end



@implementation SheetPresentationController

//| ------------------------------第一步内容----------------------------------------------
#pragma mark - UIViewControllerTransitioningDelegate
/*
 * 来告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了UIPresentationController，就返回了self
 */
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}
//| ------------------------------第二步内容----------------------------------------------
#pragma mark - 重写UIPresentationController个别方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}


// 呈现过渡即将开始的时候被调用的
// 可以在此方法创建和设置自定义动画所需的view
- (void)presentationTransitionWillBegin
{
    // 背景遮罩
    
    
    [self.containerView addSubview:self.dimmingView]; // 添加到动画容器View中。
    
    // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    // 动画期间，背景View的动画方式
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.4f;
    } completion:NULL];
}

#pragma mark 点击了背景遮罩view
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    // 在取消动画的情况下，可能为NO，这种情况下，应该取消视图的引用，防止视图没有释放
    if (!completed)
    {
        self.dimmingView = nil;
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed == YES)
    {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
    }
}

// 返回目标控制器Viewframe
- (CGRect)frameOfPresentedViewInContainerView
{
    CGFloat height = self.showHeigth>0?self.showHeigth:300.f;
    CGFloat leftM = self.showInsets.left>0?self.showInsets.left:0;
    CGFloat rightM = self.showInsets.right>0?self.showInsets.right:0;

    CGFloat bottomM = self.showInsets.bottom>0?self.showInsets.bottom:0;
    CGRect containerViewBounds = self.containerView.bounds;
    containerViewBounds.origin.y = containerViewBounds.size.height - height-bottomM;
    containerViewBounds.origin.x = leftM;
    containerViewBounds.size.width = containerViewBounds.size.width - leftM - rightM;
    containerViewBounds.size.height = height;
    return containerViewBounds;
}
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用UIContentContainer的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController) {
        [self.containerView setNeedsLayout];
    }
}
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

#pragma mark - getter and setter
- (UIView *)dimmingView
{
    if (!_dimmingView) {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.opaque = NO; //是否透明
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
        _dimmingView = dimmingView;
    }
    return _dimmingView;
}
@end
// 实现 UIViewControllerAnimatedTransitioning 协议，处理动画细节处理。第三步的内容。

@interface AlertPresentationController () <UIViewControllerAnimatedTransitioning>
/** 黑色半透明背景 */
@property (nonatomic, strong) UIView *dimmingView;

@end


@implementation AlertPresentationController

//| ------------------------------第一步内容----------------------------------------------
#pragma mark - UIViewControllerTransitioningDelegate
/*
 * 来告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了UIPresentationController，就返回了self
 */
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}

// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}
// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}



//| ------------------------------第二步内容----------------------------------------------
#pragma mark - 重写UIPresentationController个别方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}


// 呈现过渡即将开始的时候被调用的
// 可以在此方法创建和设置自定义动画所需的view
- (void)presentationTransitionWillBegin
{
    // 背景遮罩
    
    
    [self.containerView addSubview:self.dimmingView]; // 添加到动画容器View中。
    
    // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    // 动画期间，背景View的动画方式
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.4f;
    } completion:NULL];
}

#pragma mark 点击了背景遮罩view
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    // 在取消动画的情况下，可能为NO，这种情况下，应该取消视图的引用，防止视图没有释放
    if (!completed)
    {
        self.dimmingView = nil;
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed == YES)
    {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
    }
}


//| --------以下四个方法，是按照苹果官方Demo里的，都是为了计算目标控制器View的frame的----------------
//  当 presentation controller 接收到
//  -viewWillTransitionToSize:withTransitionCoordinator: message it calls this
//  method to retrieve the new size for the presentedViewController's view.
//  The presentation controller then sends a
//  -viewWillTransitionToSize:withTransitionCoordinator: message to the
//  presentedViewController with this size as the first argument.
//
//  Note that it is up to the presentation controller to adjust the frame
//  of the presented view controller's view to match this promised size.
//  We do this in -containerViewWillLayoutSubviews.
//
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

//在我们的自定义呈现中，被呈现的 view 并没有完全完全填充整个屏幕，
//被呈现的 view 的过渡动画之后的最终位置，是由 UIPresentationViewController 来负责定义的。
//我们重载 frameOfPresentedViewInContainerView 方法来定义这个最终位置
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
}

//  This method is similar to the -viewWillLayoutSubviews method in
//  UIViewController.  It allows the presentation controller to alter the
//  layout of any custom views it manages.
//
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}


//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用UIContentContainer的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}



//| ------------------------------第三步内容----------------------------------------------
#pragma mark UIViewControllerAnimatedTransitioning具体动画实现
// 动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.35 : 0;
}

// 核心，动画效果的实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    // 1.获取源控制器、目标控制器、动画容器View
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    __unused UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 2. 获取源控制器、目标控制器 的View，但是注意二者在开始动画，消失动画，身份是不一样的：
    // 也可以直接通过上面获取控制器获取，比如：toViewController.view
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //必须添加到动画容器View上。
    [containerView addSubview:toView];
    // 判断是present 还是 dismiss
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    if (isPresenting) {
        CGFloat screenW = CGRectGetWidth(containerView.bounds);
        CGFloat screenH = CGRectGetHeight(containerView.bounds);
        BOOL isUseSize = (self.showSize.width > 0 && self.showSize.height > 0);
        CGFloat h ,w ,y,x;
        if (isUseSize) {
            h = self.showSize.height>screenH?screenH:self.showSize.height;
            w = self.showSize.width>screenW?screenW:self.showSize.width;
            y = (screenH - h) * 0.5;
            x = (screenW - w) * 0.5;
        } else {
            x = self.showInsets.top;
            if (x < 0) {
                x = 0;
            }
            y = self.showInsets.left;
            if (y < 0) {
                y = 0;
            }
            CGFloat right = self.showInsets.right;
            if (right < 0) {
                right = 0;
            }
            CGFloat bottom = self.showInsets.bottom;
            if (bottom < 0) {
                bottom = 0;
            }
            w = screenW - x - right;
            h = screenH - y - bottom;
        }
        
        
        toView.frame = CGRectMake(x, y, w, h);
        toView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        toView.alpha = 0;
        
    }
    
    
    [UIView animateWithDuration:.35 animations:^{
        
        if (isPresenting) {
            toView.alpha = 1;
            toView.transform = CGAffineTransformMakeScale(1, 1);
            
            
        } else {
            fromView.alpha = 0.0;
            
        }
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)animationEnded:(BOOL) transitionCompleted{}
#pragma mark - getter and setter
- (UIView *)dimmingView
{
    if (!_dimmingView) {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        // 这里改你需要的背景蒙板颜色
        dimmingView.backgroundColor = [UIColor blackColor];
        //是否透明
        dimmingView.opaque = NO;
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
        _dimmingView = dimmingView;
    }
    return _dimmingView;
}

@end
