//
//  HSDialogView.h
//  HSDialog_Example
//
//  Created by songhe on 2020/10/9.
//  Copyright © 2020 hesong_ios@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSDialogView : UIView <CAAnimationDelegate>
// 背景 view
@property (nonatomic, weak) UIView *background;
// 标题 label
@property (nonatomic, strong) UILabel *titleLabel;
// 信息 label
@property (nonatomic, strong) UILabel *infoLabel;
// 错误码版本号 label
@property (nonatomic, strong) UILabel *codeLabel;

@property (nonatomic, assign, readonly) CGRect screenBounds;

/**
 弹窗视图布局代码，重载以编写
 */
- (void)updateRect;

/**
 背景视图设置代码，重载以编写
 */
- (void)updateWindow;

/**
 用于确定弹窗是否要自动消失，重载
 */
- (BOOL)shouldAutoDismiss;

/**
 淡入动画成功后回调
 */
@property (nonatomic,copy) void(^didAnimateIn)(void);

/**
 淡出动画成功后回调
 */
@property (nonatomic,copy) void(^didAnimateOut)(void);

/**
 淡入动画
 */
- (void)animateIn;

/**
 淡出动画
 */
- (void)animateOut;

@end


#pragma mark - 带交互按钮的弹窗，类似HUD提示
@interface HSDialogTipsView : HSDialogView
@end



#pragma mark - 带交互按钮的弹窗

@interface HSDialogConfirmView : HSDialogView
/**
 确认按钮的回调
 */
@property (nonatomic,copy) void(^confirmAction)(void);
/**
 取消和关闭的按钮回调
 */
@property (nonatomic,copy) void(^cancelAction)(void);
/**
 按钮
 */
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *cancelButton;

@end
