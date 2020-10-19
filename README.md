# HSDialog 通用弹窗

## 前言

在每个项目中，弹框的需求各种各样，HSDialog采用链式语法提供一系列的自定义显示布局为项目提供更方便的弹窗调用，省心省力! 提高开发效率!

## 特性

1、info弹窗，显示若干时间消失
元素：信息，错误码，版本号
自定义：信息（字体，颜色）消失时间

2、Alert弹窗，需要交互消失
元素：标题，信息，版本号，错误码，关闭按钮，交互按钮(取消，确定)
自定义：标题（字体,颜色）、信息（字体,颜色）, 交互按钮  (背景颜色，事件，文字)

1、标题+信息+关闭按钮+版本号+错误码
2、信息+关闭按钮
3、标题+信息+确定按钮
4、标题+信息+确定按钮+取消按钮
5、标题+信息+确定按钮
6、等等..详见demo

## 调用方式

```objective-c
样式1 ：hud
HSDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的hud").errorCode(@"-100").version(@"108001").hud();
 
样式2 ：alert
HSDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的确认按钮取消按钮的alert").errorCode(@"-100").version(@"108001").confirm(@"确认",^{}).cancel(@"取消",^{}).show();
```

## 效果演示

更多用法见demo

![演示GIF](https://github.com/tukzi/Resource/blob/master/dialog_show.gif?raw=true)

## 安装

pod 'HSDialog'

## 作者

songhe

