//
//  HSDialog.h
//  Pods

//  Created by songhe on 2020/9/3.
//

#import <Foundation/Foundation.h>

@interface HSDialog : NSObject

#pragma mark - 默认设置

/**
 样式1 ：hud
 HSDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的hud").errorCode(@"-100").version(@"108001").hud();
 
 样式2 ：alert
 HSDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的确认按钮取消按钮的alert").errorCode(@"-100").version(@"108001").confirm(@"确认",^{}).cancel(@"取消",^{}).show();
 
 */

/**
 弹窗视图全局默认设置
 */
@property (nonatomic, copy, class) UIColor *styleColor; // 设置主题颜色，默认为蓝色
@property (nonatomic, assign, class) NSTimeInterval timeout; // 设置弹窗停留时间，只针对无按钮弹窗，默认为2S

@property (nonatomic, copy, class) UIFont *alertFont; // 设置弹窗标题内容字体 默认为 Blod 18
@property (nonatomic, copy, class) UIFont *infoFont;  // 设置弹窗内容字体  默认为system 16
@property (nonatomic, copy, class) UIFont *codeFont;  // 设置弹窗错误码以及版本号字体  默认为system 13

@property (nonatomic, copy, class) UIFont *buttonFont; // 设置按钮字体  默认为system 18

@property (nonatomic, assign, class) NSTimeInterval animationTime; // 设置动画时间 默认为 0.25
@property (nonatomic, copy, class) NSString *defaultVersion; // 设置默认版本号 默认为空

#pragma mark - 弹窗调用参数

/**
 创建一个弹窗，参数为标题
 */
+ (HSDialog * (^)(NSString *))alert;

/**
 标题字体
 */
- (HSDialog * (^)(UIFont *))titleFont;

/**
 标题颜色
 */
- (HSDialog * (^)(UIColor *))titleColor;

/**
 描述
 */
- (HSDialog * (^)(NSString *))info;

/**
 描述字体
 */
- (HSDialog * (^)(UIFont *))infoFont;

/**
 描述颜色
 */
- (HSDialog * (^)(UIColor *))infoColor;

/**
 设置弹窗的错误码
 */
- (HSDialog * (^)(NSString *))errorCode;

/**
 设置弹窗的版本号
 */
- (HSDialog * (^)(NSString *))version;

/**
 设置是否隐藏x
 */
- (HSDialog * (^)(BOOL))hiddenClose;

/**
 设置弹窗确认按钮
 */
- (HSDialog * (^)(NSString *, void (^)(void)))confirm;

/**
 设置弹窗取消按钮
 */
- (HSDialog * (^)(NSString *, void (^)(void)))cancel;


/**
 弹出自动消失的hud
 */
- (void (^)(void))hud;

/**
 弹出需要手动交互的alert
 */
- (void (^)(void))show;



@end

