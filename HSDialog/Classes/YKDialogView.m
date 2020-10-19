//
//  YKDialogView.m
//  YKDialog_Example
//
//  Created by songhe on 2020/10/9.
//  Copyright © 2020 hesong_ios@163.com. All rights reserved.
//

#import "YKDialogView.h"
#import "YKDialog.h"

#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [str isEqualToString:@"<null>"] ? YES : NO )

@implementation YKDialogView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = YKDialog.alertFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.font = YKDialog.infoFont;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
        _codeLabel.font = YKDialog.codeFont;
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_codeLabel];
    }
    return _codeLabel;
}

- (CGRect)screenBounds {
    return [UIScreen mainScreen].bounds;
}

- (void)updateRect {
    CGRect frame = self.frame;
    frame.size.width = self.screenBounds.size.width - (48 * 2);
    self.frame = frame;
}

- (BOOL)shouldAutoDismiss {
    return YES;
}

- (void)updateWindow {
    self.background.backgroundColor = [UIColor clearColor];
}

- (void)animateIn {
    if (!self.didAnimateIn) {
        return;
    }
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1.2);
    scale.toValue = @(1.0);
    scale.duration = YKDialog.animationTime;
    scale.delegate = self;
    scale.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(0);
    fade.toValue = @(1);
    fade.duration = YKDialog.animationTime;
    fade.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    [self.layer addAnimation:scale forKey:@"scale"];
    [self.layer addAnimation:fade forKey:@"opacity"];
    scale.delegate = nil;
}
- (void)animateOut{
    if (!self.didAnimateOut) {
        return;
    }
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1.0);
    scale.toValue = @(1.2);
    scale.duration = YKDialog.animationTime;
    scale.delegate = self;
    scale.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    scale.removedOnCompletion = NO;
    scale.fillMode = kCAFillModeForwards;
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(1);
    fade.toValue = @(0);
    fade.duration = YKDialog.animationTime;
    fade.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    fade.removedOnCompletion = NO;
    fade.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scale forKey:@"scale"];
    [self.layer addAnimation:fade forKey:@"opacity"];
    scale.delegate = nil;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.layer removeAllAnimations];
    void (^action)(void);
    if (self.didAnimateIn) {
        action = self.didAnimateIn;
        self.didAnimateIn = nil;
    }else if (self.didAnimateOut) {
        action = self.didAnimateOut;
        self.didAnimateOut = nil;
    }
    if (action) {
        action();
    }
}

@end


@implementation YKDialogTipsView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.infoLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)updateRect {
    [super updateRect];
    CGRect frame = self.frame;
    
    CGRect titleRect = CGRectZero;
    if (!StringIsEmpty(self.titleLabel.text)) {
        titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    }

    
    CGRect infoRect = [self.infoLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil];
    
    CGRect codeRect = CGRectZero;
    if(self.codeLabel.text) {
        codeRect = [self.codeLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:self.codeLabel.font} context:nil];
    }
    
    frame.size.height = (titleRect.size.height > 0 ? (titleRect.size.height + 19+10) : 20) + infoRect.size.height + (codeRect.size.height>0?(codeRect.size.height+10):10)+21;
    
    self.frame = frame;
    self.center = CGPointMake(self.screenBounds.size.width / 2, self.screenBounds.size.height / 2);
    
    self.titleLabel.frame = CGRectMake(frame.size.width/2-titleRect.size.width/2, 19, titleRect.size.width, titleRect.size.height);
    self.infoLabel.frame = CGRectMake(frame.size.width/2-infoRect.size.width/2, CGRectGetMaxY(self.titleLabel.frame)+(titleRect.size.height > 0?10:0), infoRect.size.width, infoRect.size.height);
    self.codeLabel.frame = CGRectMake(frame.size.width/2-codeRect.size.width/2, CGRectGetMaxY(self.infoLabel.frame)+10, codeRect.size.width, codeRect.size.height);
    
    if (StringIsEmpty(self.titleLabel.text) && StringIsEmpty(self.codeLabel.text)) {
        self.infoLabel.center = CGPointMake(frame.size.width / 2 ,
                                            frame.size.height / 2);
    }
}

- (BOOL)shouldAutoDismiss {
    return YES;
}

@end


@implementation YKDialogConfirmView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)updateRect {
    [super updateRect];
    CGRect frame = self.frame;
    
    CGRect titleRect = CGRectZero;
    if (!StringIsEmpty(self.titleLabel.text)) {
        titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    }

    
    CGRect infoRect = [self.infoLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:self.infoLabel.font} context:nil];
    CGRect codeRect = CGRectZero;
    if(!StringIsEmpty(self.codeLabel.text)) {
        codeRect = [self.codeLabel.text boundingRectWithSize:CGSizeMake(frame.size.width - 30, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:self.codeLabel.font} context:nil];
    }
    
    
    self.titleLabel.frame = CGRectMake(frame.size.width/2-titleRect.size.width/2, titleRect.size.height > 0 ?20:0, titleRect.size.width, titleRect.size.height);
    self.infoLabel.frame = CGRectMake(frame.size.width/2-infoRect.size.width/2, CGRectGetMaxY(self.titleLabel.frame)+(titleRect.size.height > 0 ?25:35), infoRect.size.width, infoRect.size.height);
    self.codeLabel.frame = CGRectMake(frame.size.width/2-codeRect.size.width/2, CGRectGetMaxY(self.infoLabel.frame)+21, codeRect.size.width, codeRect.size.height);
    
    self.cancelButton.frame = CGRectMake(15, CGRectGetMaxY(self.codeLabel.frame)+15,
                                          self.confirmButton.hidden ? frame.size.width - 30 : (frame.size.width - 40) / 2,
                                          45);
    
    self.confirmButton.frame = CGRectMake(self.cancelButton.hidden?15:CGRectGetMaxX(self.cancelButton.frame)+10, CGRectGetMaxY(self.codeLabel.frame)+15,
                                         self.cancelButton.hidden ? frame.size.width - 30 : (frame.size.width - 40) / 2,
                                         45);
    
    self.closeButton.frame = CGRectMake(frame.size.width - 30, 15, 15, 15);
    
    BOOL allBtnHidden = self.confirmButton.hidden && self.cancelButton.hidden;
    
    
    frame.size.height = (titleRect.size.height > 0 ? (titleRect.size.height + 20+25) : 35) +
    infoRect.size.height +
    21 +
    (codeRect.size.height>0?(codeRect.size.height+(allBtnHidden?0:15)):(allBtnHidden?0:15)) +
    ((allBtnHidden) ? 0 : self.confirmButton.frame.size.height) +
    15;
    self.frame = frame;
    self.center = CGPointMake(self.screenBounds.size.width / 2, self.screenBounds.size.height / 2);
    
}

- (void)animateIn {
    [super animateIn];
    CABasicAnimation *backgroundFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    backgroundFade.fromValue = @(0);
    backgroundFade.toValue = @(1);
    backgroundFade.duration = YKDialog.animationTime;
    backgroundFade.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    [self.background.layer addAnimation:backgroundFade forKey:@"winOpacity"];
}

- (void)animateOut {
    [super animateOut];
    CABasicAnimation *backgroundFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    backgroundFade.fromValue = @(1);
    backgroundFade.toValue = @(0);
    backgroundFade.removedOnCompletion = NO;
    backgroundFade.fillMode = kCAFillModeForwards;
    backgroundFade.duration = YKDialog.animationTime;
    backgroundFade.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :1];
    [self.background.layer addAnimation:backgroundFade forKey:@"winOpacity"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [super animationDidStop:anim finished:flag];
    [self.background.layer removeAllAnimations];
}

- (void)updateWindow {
    self.background.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.64];
}

- (BOOL)shouldAutoDismiss {
    return NO;
}

- (void)buttonTap:(UIButton *)button {
    [self animateOut];
    if (button == self.confirmButton) {
        if (self.confirmAction) self.confirmAction();
    }else if (button == self.cancelButton || button == self.closeButton) {
        if (self.cancelAction) self.cancelAction();
    }
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                                    stringByAppendingPathComponent:@"/YKDialog.bundle"];
        NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *image = [UIImage imageNamed:@"yk_dialog_close_icon"
                                        inBundle:resource_bundle
                   compatibleWithTraitCollection:nil];
        [_closeButton setImage:image forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.layer.cornerRadius = 3;
        _confirmButton.titleLabel.font =  YKDialog.buttonFont;
        _confirmButton.backgroundColor = YKDialog.styleColor;
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.layer.cornerRadius = 3;
        _cancelButton.layer.borderColor = YKDialog.styleColor.CGColor;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.titleLabel.font =  YKDialog.buttonFont;
        [_cancelButton setTitleColor:YKDialog.styleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}


@end
