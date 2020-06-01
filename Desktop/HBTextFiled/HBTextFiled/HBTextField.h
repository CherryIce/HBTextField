//
//  HBTextField.h
//  HBTextFiled
//
//  Created by Mr.Zhu on 30/05/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBTextFieldDelegate <NSObject>

@optional
- (void) textFiledDidChanedText:(NSString *_Nullable) text;

/**  UITextFieldDelegate   */
- (BOOL) hbtextFieldShouldBeginEditing:(UITextField *_Nullable)textField;
- (void) hbtextFieldDidBeginEditing:(UITextField *_Nullable)textField;
- (BOOL) hbtextFieldShouldEndEditing:(UITextField *_Nullable)textField;
- (void) hbtextFieldDidEndEditing:(UITextField *_Nullable)textField;
- (void) hbtextFieldDidEndEditing:(UITextField *_Nullable)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0));
- (BOOL) hbtextField:(UITextField *_Nullable)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *_Nullable)string;
- (void) hbtextFieldDidChangeSelection:(UITextField *_Nullable)textField;
- (BOOL) hbtextFieldShouldClear:(UITextField *_Nullable)textField;
- (BOOL) hbtextFieldShouldReturn:(UITextField *_Nonnull)textField;

@end

typedef NS_ENUM(NSUInteger, HBTextFieldInputTextType) {
    HBInputTextNormalType,//默认
    HBInputTextOnlyNumberType,//纯数字
    HBInputTextNumberPointType,//数字+小数点
    HBInputTextNumberAlphaType,//数字+字母
    HBInputTextPasswordType,//除中文和特殊字符以外
    HBInputTextURLType,//URL
    HBInputTextEamilType//邮箱
};

NS_ASSUME_NONNULL_BEGIN

@interface HBTextField : UITextField<UITextFieldDelegate>

@property (nonatomic , assign) NSInteger maxLength;

@property (nonatomic , assign) HBTextFieldInputTextType type;

@property (nonatomic , weak) id<HBTextFieldDelegate> hbDelegate;

@end

NS_ASSUME_NONNULL_END
