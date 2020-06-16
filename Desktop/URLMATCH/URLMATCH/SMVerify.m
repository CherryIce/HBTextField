//
//  SMVerify.m
//  URLMATCH
//
//  Created by Mr.Zhu on 15/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "SMVerify.h"

#define URLHASPrefixArr @[@"http:",@"http:/",@"http://",@"https:",@"https:/",@"https://"]

#define REPLACEArr @[@"http~",@"http~~",@"http~~~",@"https~",@"https~~",@"https~~~"]

@implementation SMVerify

+ (NSMutableAttributedString *) verifyStringIsContainURLString:(NSString *)urlString andSetColor:(UIColor *)color font:(UIFont *)font {
    //用空格分开中英文数字
    urlString = [SMVerify jungleNearChatacter:urlString];
    //将http替换
    int count = (int)(URLHASPrefixArr.count-1);
    for (int i = count; i >= 0; i--) {
        NSString * curent = URLHASPrefixArr[i];
        if ([urlString containsString:curent]) {
            urlString = [urlString stringByReplacingOccurrencesOfString:curent withString:REPLACEArr[i]];
        }
    }
    return [SMVerify verifyWithString:urlString color:color];
}

+ (NSMutableAttributedString *) verifyWithString:(NSString * )string color:(UIColor *)color {
    NSError * error = nil;
    NSMutableAttributedString * attributeStr;
    if (string.length > 0) {
        NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
           //NSTextCheckingTypePhoneNumber
        NSArray *matches = [detector matchesInString:string
                                             options:NSMatchingWithoutAnchoringBounds
                                               range:NSMakeRange(0, [string length])];
        
        attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if ([match resultType] == NSTextCheckingTypeLink) {
                 [attributeStr setAttributes:@{NSForegroundColorAttributeName:color} range:matchRange];
            }
        }
        NSString * urlString = attributeStr.string;
        int count = (int)(REPLACEArr.count-1);
        for (int i = count; i >= 0; i--) {
            NSString * curr = REPLACEArr[i];
            if ([urlString containsString:curr]) {
                 NSMutableAttributedString * currAtt = [[NSMutableAttributedString alloc] initWithString:URLHASPrefixArr[i] attributes:@{NSForegroundColorAttributeName:color}];
                //将http换回来
                NSRegularExpression *regexs = [NSRegularExpression regularExpressionWithPattern:curr options:NSRegularExpressionDotMatchesLineSeparators error:&error];
                NSArray *matchs = [regexs matchesInString:urlString options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [urlString length])];
                for (NSTextCheckingResult *match2 in matchs) {
                    NSRange matchRange2 = [match2 range];
                    [attributeStr replaceCharactersInRange:matchRange2 withAttributedString:currAtt];
                }
            }
        }
        //将空格去掉
        NSRegularExpression *regexss = [NSRegularExpression regularExpressionWithPattern:@" " options:NSRegularExpressionDotMatchesLineSeparators error:&error];
        NSArray *matchss = [regexss matchesInString:attributeStr.string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [attributeStr.string length])];
        NSInteger index = 0;
        for (NSTextCheckingResult *match2s in matchss) {
            NSRange matchRange2s = [match2s range];
            [attributeStr deleteCharactersInRange:NSMakeRange(matchRange2s.location-index, matchRange2s.length)];
            index += 1;
        }
    }
    return attributeStr;
}

+ (NSString *) jungleNearChatacter:(NSString *) str {
    NSMutableString * temp = [[NSMutableString alloc] initWithString:str];
    NSInteger index = 0;
    for (int i = 0; i < [str length]; i++) {
        if (i < ([str length] - 1)) {
            int a = [str characterAtIndex:i];
            int b = [str characterAtIndex:i+1];
            BOOL a1 = [SMVerify isChineseChatacher:a];
            BOOL a2 = [SMVerify isNumberOrAlpha:a];
            BOOL b1 = [SMVerify isChineseChatacher:b];
            BOOL b2 = [SMVerify isNumberOrAlpha:b];
            
            if ((a1&&b2) || (a2&&b1)) {
                [temp insertString:@" " atIndex:i+1+index];
                index += 1;
            }
        }
    }
    return temp;
}

+ (BOOL) isChineseChatacher:(int)charactIndex {
    if( charactIndex > 0x4E00 && charactIndex < 0x9FFF){
        return YES;
    }
    return NO;
}

+ (BOOL) isNumberOrAlpha:(int)charactIndex {
    if ((charactIndex >= 97 && charactIndex <= 122) || (charactIndex >= 65 && charactIndex <= 90) || (charactIndex >= 48 && charactIndex <= 57)) {
        return YES;
    }
    return NO;
}


//http://www.baidu.com你好

@end
