//
//  HBTextField.m
//  HBTextFiled
//
//  Created by Mr.Zhu on 30/05/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "HBTextField.h"

#define NUM @"0123456789"//只输入数字
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"//只输入字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"//数字和字母

@interface HBTextField ()

@property (nonatomic , assign) __block bool isExistPoint;

@end

@implementation HBTextField

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addDeletegate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addDeletegate];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self == [super initWithCoder:coder]) {
        [self addDeletegate];
    }
    return self;
}

- (void) addDeletegate {
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    //[self addTarget:self.superview action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
}

- (void)setType:(HBTextFieldInputTextType)type {
    _type = type;
    switch (_type) {
        case HBInputTextNormalType:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case HBInputTextOnlyNumberType:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case HBInputTextNumberPointType:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case HBInputTextNumberAlphaType:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case HBInputTextPasswordType:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case HBInputTextURLType:
            self.keyboardType = UIKeyboardTypeURL;
            break;
        case HBInputTextEamilType:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            break;
    }
}

#pragma mark -- limit1
- (void)textEditChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
//    if (textField != self.inputView) {
//        return;
//    }
    // 需要限制的长度
    NSUInteger maxLength = _maxLength;
    
    // text field 的内容a
    NSString *contentText = textField.text;
    
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 这行代码 可以认为是 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        // 如果 text field 的内容长度大于我们限制的内容长度
        if (contentText.length > maxLength) {
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [contentText substringWithRange:rangeRange];
        }
    }
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(textFiledDidChanedText:)]) {
        [self.hbDelegate textFiledDidChanedText:textField.text];
    }
}

#pragma mark -- limit2
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > _maxLength) {
        textField.text = [textField.text substringToIndex:_maxLength];
    }
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(textFiledDidChanedText:)]) {
        [self.hbDelegate textFiledDidChanedText:textField.text];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldDidBeginEditing:)]) {
        [self.hbDelegate hbtextFieldDidBeginEditing:textField];
    }
    return YES;
}

#pragma  ===== UITextFieldDelegate ========
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldDidBeginEditing:)]) {
        [self.hbDelegate hbtextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldDidBeginEditing:)]) {
        [self.hbDelegate hbtextFieldDidBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldDidEndEditing:)]) {
        [self.hbDelegate hbtextFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [self.hbDelegate hbtextFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
   if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldDidChangeSelection:)]) {
        [self.hbDelegate hbtextFieldDidChangeSelection:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldShouldClear:)]) {
        [self.hbDelegate hbtextFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextFieldShouldReturn:)]) {
        [self.hbDelegate hbtextFieldShouldReturn:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_type == HBInputTextNumberPointType) {
        /*
        * 不能输入.0-9以外的字符。
        * 设置输入框输入的内容格式
        * 只能有一个小数点
        * 如果第一位是.则前面加上0.
        * 如果第一位是0则后面必须输入点，否则不能输入。
        */
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isExistPoint = YES;
        }else{
            self.isExistPoint = NO;
        }
        
        if (string.length > 0) {
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isExistPoint && single == '.') {
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
            }
        }
    }
    if (_type == HBInputTextOnlyNumberType) {
        NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)  {
            return NO;
        }
    }
    if (_type == HBInputTextNumberAlphaType) {
        NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)  {
            return NO;
        }
    }
    
    if (_type == HBInputTextPasswordType && _type == HBInputTextEamilType && _type == HBInputTextURLType) {
        if (![self validatePwd:string]) {
            return NO;
        }
    }
    
    if (self.hbDelegate && [self.hbDelegate respondsToSelector:@selector(hbtextField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.hbDelegate hbtextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

//判断是否是中文
- (BOOL)isChinese:(NSString *)string {
    NSString *regex = @"^[\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//非中文和特殊符号
- (BOOL)validatePwd:(NSString *)param {
    NSString *pwdRegex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdPredicate evaluateWithObject:param];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
