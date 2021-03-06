//
//  UIView+Helper.m
//  UIHelper
//
//  Created by suhc on 2017/6/13.
//  Copyright © 2017年 hclib. All rights reserved.
//

#import "UIView+Helper.h"
#import "UIHelper.h"

NSMutableArray *_textFields;
UITextField *_currentField;
UIAlertController *_alert;
@implementation UIView (Helper)

- (void)addUIHelperRecursive:(BOOL)recursive{
#ifdef DEBUG
    if (![UIHelper sharedHelper].isEnabled) {
        return;
    }
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIImageView class]]) {
        self.userInteractionEnabled = YES;
    }
    UITapGestureRecognizer *showAlertTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeFrameAlert)];
    showAlertTap.numberOfTapsRequired = 2;
    if (recursive) {
        for (UIView *subView in self.subviews) {
            [subView addUIHelperRecursive:recursive];
        }
    }
    [self addGestureRecognizer:showAlertTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
#endif
}

#pragma mark - 属性列表
- (void)showChangeFrameAlert{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    _textFields = [NSMutableArray array];
    NSString *title = [NSString stringWithFormat:@"%@",NSStringFromClass(self.class)];
    NSString *message = [NSString stringWithFormat:@"%@",NSStringFromCGRect(self.frame)];
    _alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //0.x
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.frame.origin.x];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.frame.origin.x];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"x=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //1.y
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.frame.origin.y];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.frame.origin.y];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"y=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //2.width
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.frame.size.width];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.frame.size.width];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"width=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //3.height
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.frame.size.height];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.frame.size.height];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"height=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //4.backgroundColor
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = [NSString stringWithFormat:@"backgroundColor=%@",[self hexStrForColor:self.backgroundColor]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addInputAccessoryViewForField:textField isColor:YES];
    }];
    //UILabel && UIButton
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIButton class]]) {
        //5.font
        [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            CGFloat font = 0;
            if ([self isKindOfClass:[UILabel class]]) {
                font = ((UILabel *)self).font.pointSize;
            }else{
                font = ((UIButton *)self).titleLabel.font.pointSize;
            }
            textField.placeholder = [NSString stringWithFormat:@"fontsize=%.f",font];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [self addInputAccessoryViewForField:textField isColor:NO];
        }];
        //6.textColor
        [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            UIColor *textColor = nil;
            if ([self isKindOfClass:[UILabel class]]) {
                textColor = ((UILabel *)self).textColor;
            }else{
                textColor = ((UIButton *)self).titleLabel.textColor;
            }
            textField.placeholder = [NSString stringWithFormat:@"textColor=%@",[self hexStrForColor:textColor]];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [self addInputAccessoryViewForField:textField isColor:YES];
        }];
    }
    //7.borderWidth
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.layer.borderWidth];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.layer.borderWidth];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"borderWidth=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //8.borderColor
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"borderColor=%@",[self hexStrForColor:[UIColor colorWithCGColor:self.layer.borderColor]]];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addInputAccessoryViewForField:textField isColor:YES];
    }];
    //9.cornerRadius
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.layer.cornerRadius];
        NSString *text1 = [NSString stringWithFormat:@"%.1f",self.layer.cornerRadius];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"cornerRadius=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //10.backgroundColor.alpha
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *alpha = [self alphaStrForColor:self.backgroundColor];
        
        NSString *text0 = [NSString stringWithFormat:@"%.f",alpha.floatValue];
        NSString *text1 = [NSString stringWithFormat:@"%.2f",alpha.floatValue];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        textField.placeholder = [NSString stringWithFormat:@"backgroundColor.alpha=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    //11.self.alpha
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *placeholder = nil;
        NSString *text0 = [NSString stringWithFormat:@"%.f",self.alpha];
        NSString *text1 = [NSString stringWithFormat:@"%.2f",self.alpha];
        placeholder = text0;
        if (text0.floatValue != text1.floatValue) {
            placeholder = text1;
        }
        
        textField.placeholder = [NSString stringWithFormat:@"self.alpha=%@",placeholder];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addInputAccessoryViewForField:textField isColor:NO];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self confirmAction];
    }];
    [_alert addAction:confirm];
    [[self getController] presentViewController:_alert animated:YES completion:nil];
}

#pragma mark - 确定
- (void)confirmAction{
    //0.x
    UITextField *xField = _alert.textFields[0];
    //1.y
    UITextField *yField = _alert.textFields[1];
    //2.width
    UITextField *widthField = _alert.textFields[2];
    //3.height
    UITextField *heightField = _alert.textFields[3];
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (xField.text.length > 0) {
        x = xField.text.floatValue;
    }
    if (yField.text.length > 0) {
        y = yField.text.floatValue;
    }
    if (widthField.text.length > 0) {
        width = widthField.text.floatValue;
    }
    if (heightField.text.length > 0) {
        height = heightField.text.floatValue;
    }
    self.frame = CGRectMake(x, y, width, height);
    //4.backgroundColor
    UITextField *backgroundColorField = _alert.textFields[4];
    if (backgroundColorField.text.length > 0) {
        self.backgroundColor = [self colorWithHexString:backgroundColorField.text];
    }
    //UILabel && UIButton
    UITextField *borderWidthField = nil;
    UITextField *borderColorField = nil;
    UITextField *cornerRadiusField = nil;
    UITextField *backgroundColorAlphaField = nil;
    UITextField *selfAlphaField = nil;
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIButton class]]) {
        //5.font
        UITextField *fontField = _alert.textFields[5];
        if (fontField.text.length > 0) {
            if ([self isKindOfClass:[UILabel class]]) {
                ((UILabel *)self).font = [UIFont systemFontOfSize:fontField.text.floatValue];
            }else{
                ((UIButton *)self).titleLabel.font = [UIFont systemFontOfSize:fontField.text.floatValue];
            }
        }
        //6.textColor
        UITextField *textColorField = _alert.textFields[6];
        if (textColorField.text.length > 0) {
            if ([self isKindOfClass:[UILabel class]]) {
                ((UILabel *)self).textColor = [self colorWithHexString:textColorField.text];
            }else{
                [((UIButton *)self) setTitleColor:[self colorWithHexString:textColorField.text] forState:UIControlStateNormal];
            }
        }
        borderWidthField = _alert.textFields[7];
        borderColorField = _alert.textFields[8];
        cornerRadiusField = _alert.textFields[9];
        backgroundColorAlphaField = _alert.textFields[10];
        selfAlphaField = _alert.textFields[11];
    }else{
        borderWidthField = _alert.textFields[5];
        borderColorField = _alert.textFields[6];
        cornerRadiusField = _alert.textFields[7];
        backgroundColorAlphaField = _alert.textFields[8];
        selfAlphaField = _alert.textFields[9];
    }
    //borderWidth
    if (borderWidthField.text.length > 0) {
        self.layer.borderWidth = borderWidthField.text.floatValue;
    }
    //borderColor
    if (borderColorField.text.length > 0) {
        self.layer.borderColor = [self colorWithHexString:borderColorField.text].CGColor;
    }
    //cornerRadius
    if (cornerRadiusField.text.length > 0) {
        self.layer.cornerRadius = cornerRadiusField.text.floatValue;
    }
    //backgroundColor.alpha
    if (backgroundColorAlphaField.text.length > 0) {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:backgroundColorAlphaField.text.floatValue];
    }
    //self.alpha
    if (selfAlphaField.text.length > 0) {
        self.alpha = selfAlphaField.text.floatValue;
    }
    [_alert dismissViewControllerAnimated:YES completion:^{
        [_textFields removeAllObjects];
        _textFields = nil;
        _currentField = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
        _alert = nil;
    }];
}

//获取当前view所在的controller
- (UIViewController *)getController {
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

//取出一个颜色的十六进制表示
- (NSString *)hexStrForColor:(UIColor *)color{
    if (!color) {
        color = [UIColor whiteColor];
    }
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    float r = components[0];
    float g = components[1];
    if (colorSpaceModel == kCGColorSpaceModelMonochrome){
        g = components[0];
    }
    float b = components[2];
    if (colorSpaceModel == kCGColorSpaceModelMonochrome){
        b = components[0];
    }
    
    NSInteger red = r * 255;
    NSInteger green = g * 255;
    NSInteger blue = b * 255;
    NSString *hexStr = [NSString stringWithFormat:@"#%@%@%@",[self toHex:red],[self toHex:green],[self toHex:blue]];
    
    return hexStr;
}

//透明度
- (NSString *)alphaStrForColor:(UIColor *)color{
    if (!color) {
        color = [UIColor whiteColor];
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    float alpha = components[CGColorGetNumberOfComponents(color.CGColor) - 1];
    
    return [NSString stringWithFormat:@"%.2f",alpha];
}

//把10进制转换为16进制
- (NSString *)toHex:(uint16_t)tmpid{
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig = tmpid%16;
        tmpid = tmpid/16;
        switch (ttmpig)
        {
            case 0:
                nLetterValue = @"00";break;
            case 10:
                nLetterValue = @"A";break;
            case 11:
                nLetterValue = @"B";break;
            case 12:
                nLetterValue = @"C";break;
            case 13:
                nLetterValue = @"D";break;
            case 14:
                nLetterValue = @"E";break;
            case 15:
                nLetterValue = @"F";break;
            default:
                
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

//  十六进制颜色转换为UIColor
- (UIColor *)colorWithHexString:(NSString *)hexString{
    
    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //  string should be 6 or 8 characters
    if ([colorString length] < 6) {
        return [UIColor clearColor];
    }
    
    //  strip 0X if it appears
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if ([colorString length] != 6) {
        return [UIColor clearColor];
    }
    
    //  separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //  r
    NSString *rString = [colorString substringWithRange:range];
    
    //  g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    
    //  b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    //  scan value
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:1.0f];
}

#pragma mark - 键盘处理
- (void)addInputAccessoryViewForField:(UITextField *)textField isColor:(BOOL)isColor{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    if ([textField respondsToSelector:@selector(keyboardAppearance)])
    {
        switch ([textField keyboardAppearance])
        {
            case UIKeyboardAppearanceAlert: toolbar.barStyle = UIBarStyleBlack;     break;
            default:                        toolbar.barStyle = UIBarStyleDefault;   break;
        }
    }
    
    toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    //上一个
    UIBarButtonItem *previousItem = [self getCustomItemWithImage:@"IQButtonBarArrowUp" isPrevious:YES];
    previousItem.style = UIBarButtonSystemItemFastForward;
    
    //下一个
    UIBarButtonItem *nextItem = [self getCustomItemWithImage:@"IQButtonBarArrowDown" isPrevious:NO];
    nextItem.style = UIBarButtonSystemItemFastForward;
    
    //16进制字符
    UIBarButtonItem *A = [[UIBarButtonItem alloc] initWithTitle:@"A" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    UIBarButtonItem *B = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    UIBarButtonItem *C = [[UIBarButtonItem alloc] initWithTitle:@"C" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    UIBarButtonItem *D = [[UIBarButtonItem alloc] initWithTitle:@"D" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    UIBarButtonItem *E = [[UIBarButtonItem alloc] initWithTitle:@"E" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    UIBarButtonItem *F = [[UIBarButtonItem alloc] initWithTitle:@"F" style:UIBarButtonItemStylePlain target:self action:@selector(selectHexStr:)];
    
    //中间的弹簧
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //完成
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    doneItem.style = UIBarButtonSystemItemDone;
    
    if (isColor) {
        toolbar.items = @[previousItem,nextItem,flexibleItem,A,flexibleItem,B,flexibleItem,C,flexibleItem,D,flexibleItem,E,flexibleItem,F,flexibleItem,doneItem];
    }else{
        toolbar.items = @[previousItem,nextItem,flexibleItem,doneItem];
    }
    
    textField.inputAccessoryView = toolbar;
    
    [_textFields addObject:textField];
}

- (void)done{
    [self confirmAction];
}

//上一个
- (void)previous{
    NSInteger currentIndex = [_textFields indexOfObject:_currentField];
    if (currentIndex == 0) {
        return;
    }
    _currentField = [_textFields objectAtIndex:currentIndex - 1];
    [_currentField becomeFirstResponder];
}

//下一个
- (void)next{
    NSInteger currentIndex = [_textFields indexOfObject:_currentField];
    if (currentIndex == _textFields.count - 1) {
        return;
    }
    _currentField = [_textFields objectAtIndex:currentIndex + 1];
    [_currentField becomeFirstResponder];
}

- (void)textFieldTextDidBeginEditing:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    _currentField = textField;
}

//选择16进制字符
- (void)selectHexStr:(UIBarButtonItem *)hexItem{
    NSString *originalText = _currentField.text;
    originalText = [originalText stringByAppendingString:hexItem.title];
    _currentField.text = originalText;
}

- (UIBarButtonItem *)getCustomItemWithImage:(NSString *)imageName isPrevious:(BOOL)isPrevious{
    // Get the top level "bundle" which may actually be the framework
    NSBundle *mainBundle = [NSBundle bundleForClass:[UIHelper class]];
    
    // Check to see if the resource bundle exists inside the top level bundle
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"UIHelper" ofType:@"bundle"]];
    
    if (resourcesBundle == nil) {
        resourcesBundle = mainBundle;
    }
    UIImage *image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 30.f, 44.f);
    if (isPrevious) {
        [button addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end

