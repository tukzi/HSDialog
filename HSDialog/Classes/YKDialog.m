//
//  YKDialog.m
//  Pods
//
//  Created by songhe on 2020/9/3.
//

#import "YKDialog.h"
#import "YKDialogView.h"
#import <objc/runtime.h>

static const char * const ykGetDialogWindowCachedDialogs = "yk_get_dialog_window_cached_dialogs";
static UIWindow * yk_get_dialog_window () {
    static UIWindow *window;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelAlert + 1;
        window.rootViewController = [UIViewController new];
        window.rootViewController.view.backgroundColor = [UIColor clearColor];
        window.rootViewController.view.userInteractionEnabled = NO;
        objc_setAssociatedObject(window, ykGetDialogWindowCachedDialogs, [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return window;
}
static YKDialog * yk_pop_cached_dialog () {
    NSMutableArray *array = objc_getAssociatedObject(yk_get_dialog_window(), ykGetDialogWindowCachedDialogs);
    YKDialog *dialog = [array firstObject];
    if (dialog) {
        [array removeObject:[array firstObject]];
    }
    return dialog;
}
static void yk_push_dialog (YKDialog *dialog) {
    NSMutableArray *array = objc_getAssociatedObject(yk_get_dialog_window(), ykGetDialogWindowCachedDialogs);
    [array addObject:dialog];
}

@interface YKDialog ()

//标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *tFont;
@property (nonatomic, strong) UIColor *tColor;

//提示信息
@property (nonatomic, copy) NSString *infoStr;
@property (nonatomic, strong) UIFont *iFont;
@property (nonatomic, strong) UIColor *iColor;

//错误码与版本号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *ver;

//是否隐藏关闭按钮，默认显示
@property (nonatomic, assign) BOOL isHiddenClose;

//按钮
@property (nonatomic, copy) NSString *confirmTitle,*cancelTitle;
@property (nonatomic, copy) void (^cancelAction)(void);
@property (nonatomic, copy) void (^confirmAction)(void);

@property (nonatomic, copy) UIColor *style;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation YKDialog

+ (void)load {
    YKDialog.styleColor = [self colorWithCode:0x0047BB];
    YKDialog.timeout = 2;
    YKDialog.alertFont = [UIFont boldSystemFontOfSize:18];
    YKDialog.infoFont = [UIFont systemFontOfSize:16];
    YKDialog.codeFont = [UIFont systemFontOfSize:13];
    YKDialog.buttonFont = [UIFont systemFontOfSize:18];
    YKDialog.animationTime = 0.25;
}

#pragma mark - Class property

+ (NSString *)defaultVersion {
    return objc_getAssociatedObject(self, _cmd);
}
+ (void)setDefaultVersion:(NSString *)defaultVersion {
    objc_setAssociatedObject(self, @selector(defaultVersion), defaultVersion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (UIColor *)styleColor {
    return objc_getAssociatedObject(self, _cmd);
}
+ (void)setStyleColor:(UIColor *)color {
    objc_setAssociatedObject(self, @selector(styleColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (UIFont *)alertFont {
    return objc_getAssociatedObject(self, _cmd);
}
+ (void)setAlertFont:(UIFont *)font {
    objc_setAssociatedObject(self, @selector(alertFont), font, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (UIFont *)codeFont {
    return objc_getAssociatedObject(self, _cmd);
}
+ (void)setCodeFont:(UIFont *)font {
    objc_setAssociatedObject(self, @selector(codeFont), font, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (NSTimeInterval)timeout {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).doubleValue;
}
+ (void)setTimeout:(NSTimeInterval)timeout {
    objc_setAssociatedObject(self, @selector(timeout), @(timeout), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (NSTimeInterval)animationTime {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).doubleValue;
}
+ (void)setAnimationTime:(NSTimeInterval)animationTime {
    objc_setAssociatedObject(self, @selector(animationTime), @(animationTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIFont *)buttonFont {
   return objc_getAssociatedObject(self, _cmd);
}
+ (void)setButtonFont:(UIFont *)buttonFont {
    objc_setAssociatedObject(self, @selector(buttonFont), buttonFont, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (UIFont *)infoFont {
   return objc_getAssociatedObject(self, _cmd);
}
+ (void)setInfoFont:(UIFont *)infoFont {
    objc_setAssociatedObject(self, @selector(infoFont), infoFont, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Public method

+ (YKDialog *(^)(NSString *))alert {
    YKDialog *dialog = [[YKDialog alloc] init];
    return ^YKDialog * (NSString *title) {
        dialog.title = title;
        dialog.ver = YKDialog.defaultVersion;
        dialog.style = YKDialog.styleColor;
        dialog.duration = YKDialog.timeout;
        return dialog;
    };
}

- (YKDialog *(^)(UIFont *))titleFont {
    return ^YKDialog * (UIFont *tFont) {
        self.tFont = tFont;
        return self;
    };
}

- (YKDialog *(^)(UIColor *))titleColor {
    return ^YKDialog * (UIColor *tColor) {
        self.tColor = tColor;
        return self;
    };
}

- (YKDialog * (^)(NSString *))info {
    return ^ YKDialog * (NSString * infoStr) {
        self.infoStr = infoStr;
        return self;
    };
}

- (YKDialog *(^)(UIFont *))infoFont {
    return ^ YKDialog * (UIFont * iFont) {
        self.iFont = iFont;
        return self;
    };
}

- (YKDialog *(^)(UIColor *))infoColor {
    return ^YKDialog * (UIColor *iColor) {
        self.iColor = iColor;
        return self;
    };
}

/**
 设置弹窗的错误码
 */
- (YKDialog * (^)(NSString *))errorCode {
    return ^ YKDialog * (NSString * code) {
        self.code = code;
        return self;
    };
}

/**
 设置弹窗的版本号
 */
- (YKDialog * (^)(NSString *))version {
    return ^ YKDialog * (NSString * ver) {
        self.ver = ver;
        return self;
    };
}

/**
 设置是否隐藏x
 */
- (YKDialog * (^)(BOOL))hiddenClose {
    return ^ YKDialog * (BOOL hiddenClose) {
        self.isHiddenClose = hiddenClose;
        return self;
    };
}

/**
 设置弹窗确认按钮
 */
- (YKDialog * (^)(NSString *, void (^)(void)))confirm {
    return ^YKDialog * (NSString *title,void (^confirmAction)(void)) {
        self.confirmTitle = title;
        self.confirmAction = confirmAction;
        return self;
    };
}

/**
 设置弹窗取消按钮
 */
- (YKDialog * (^)(NSString *, void (^)(void)))cancel {
    return ^YKDialog * (NSString *title,void (^cancelAction)(void)) {
        self.cancelTitle = title;
        self.cancelAction = cancelAction;
        return self;
    };
}

/**
 弹出需要交互的alert
 */
- (void (^)(void))show {
    return ^void (void) {
        UIWindow *window = yk_get_dialog_window();
        if (!window.hidden) {
            yk_push_dialog(self);
        }else {
            [self displayWithAnimationInWindow:NO];
            [yk_get_dialog_window() makeKeyAndVisible];
        }
    };
}

/**
 弹出自动消失的hud
 */
- (void (^)(void))hud {
    return ^void (void) {
        UIWindow *window = yk_get_dialog_window();
        if (!window.hidden) {
            yk_push_dialog(self);
        }else {
            [self displayWithAnimationInWindow:YES];
            [yk_get_dialog_window() makeKeyAndVisible];
        }
    };
}

#pragma mark - Showing action
- (void)displayWithAnimationInWindow:(BOOL)isHud{
    YKDialogView *view = [self makeViewWithBackground:yk_get_dialog_window() isHud:isHud];
    __weak YKDialogView *weakView = view;
    view.didAnimateIn = ^{
        if ([weakView shouldAutoDismiss]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakView animateOut];
            });
        }
    };
    view.didAnimateOut = ^{
        [weakView removeFromSuperview];
        YKDialog *dialog = yk_pop_cached_dialog();
        if (dialog) {
            [dialog displayWithAnimationInWindow:isHud];
        }else {
            yk_get_dialog_window().hidden = YES;
        }
    };
    [view animateIn];
}
- (YKDialogView *)makeViewWithBackground:(UIView *)background isHud:(BOOL)isHud{
    YKDialogView *view;
    if (isHud) {
        view = [[YKDialogTipsView alloc] init];
    }else {
        YKDialogConfirmView *confirmView = [[YKDialogConfirmView alloc] init];
        [confirmView.confirmButton setTitle:self.confirmTitle ?: @"确定" forState:UIControlStateNormal];
        [confirmView.cancelButton setTitle:self.cancelTitle ?: @"取消" forState:UIControlStateNormal];
        confirmView.confirmAction = self.confirmAction;
        confirmView.cancelAction = self.cancelAction;
        confirmView.confirmButton.hidden = self.confirmAction ? NO : YES;
        confirmView.cancelButton.hidden = self.cancelAction ? NO : YES;
        if (self.isHiddenClose) confirmView.closeButton.hidden = YES;
        view = confirmView;
    }
    view.titleLabel.text = self.title;
    if (self.tFont) view.titleLabel.font = self.tFont;
    if (self.tColor) view.titleLabel.textColor = self.tColor;
    
    view.infoLabel.text = self.infoStr;
    if (self.iFont) view.infoLabel.font = self.iFont;
    if (self.iColor) view.infoLabel.textColor = self.iColor;
    
    if (self.code && self.ver) {
        view.codeLabel.text = [NSString stringWithFormat:@"[%@ | %@]",self.code,self.ver];
    } else if (self.code) {
        view.codeLabel.text = self.code;
    } else if (self.ver) {
        view.codeLabel.text = self.ver;
    }
    
    view.background = background;
    [view updateRect];
    [view updateWindow];
    [background addSubview:view];
    return view;
}


#pragma mark - Helper

+ (UIColor *)colorWithCode:(long)code {
    return [UIColor colorWithRed:((float)((code & 0xFF0000) >> 16))/255.0 green:((float)((code & 0xFF00) >> 8))/255.0 blue:((float)(code & 0xFF))/255.0 alpha:1.0];
}

@end
