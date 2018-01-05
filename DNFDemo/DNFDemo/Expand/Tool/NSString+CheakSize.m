//
//  NSString+CheakSize.m
//  DayHr
//
//  Created by sam on 14-7-17.
//  Copyright (c) 2014年 DayHR. All rights reserved.
//

#import "NSString+CheakSize.h"

@implementation NSString (CheakSize)
+ (NSString *)changeTime:(id)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *s = [f stringFromDate:date];
    return s?:@"";
}
- (NSDate *)dateFormeString{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [f dateFromString:self];
}

+(NSString *)notRounding:(double)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)moneyStringFormFloat:(double)value{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:value]];
    return numberString;
}
- (float)floatValueFromMoney{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSNumber *num = [numberFormatter numberFromString:self];
    return [num  floatValue];
}
- (CGSize)sizeForStringwithFont:(UIFont *)font andSize:(CGSize)size{
    

        NSDictionary *attribute = @{NSFontAttributeName:font};
        
        CGSize retSize = [self boundingRectWithSize:size
                                            options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
        return retSize;
        
}
- (NSString *)changeDateDDYYMMSS{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:self];
    
    [f setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [f stringFromDate:date]== nil?@"":[f stringFromDate:date];

}
- (NSString *)changeDate{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:self];
    
    [f setDateFormat:@"yyyy年MM月dd日"];
    return [f stringFromDate:date]== nil?@"":[f stringFromDate:date];
}
- (NSString *)calculateDate{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:self];
    float part = 0;
    NSString *name = nil;
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
    if (time < 60) {
        time = 1;
        part = 1;
        return @"刚刚";
    }else if (time < 60*60) {//小于一个小时
        name = @"分钟";
        part = 60;
        
    }else if (time < 60*60*24){
        name = @"小时";
        part = 60*60;
    }else{
        [f setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [f stringFromDate:date];
    }
    
    return [NSString stringWithFormat:@"%.0f%@前",time/part,name];
}
- (NSString *)compleFinshTime:(NSString *)finshTime{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:self];
    NSDate *fDate = [f dateFromString:finshTime];
    NSTimeInterval interval = [fDate timeIntervalSinceDate:date];
    if (interval== 0) {
        return @"准时";
    }else if(interval > 0 ){
        return @"延迟";
    }else{
        return @"提前";
    }
    
}
- (NSTimeInterval)changeTimeInterval{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [f dateFromString:self];
    return [date  timeIntervalSince1970]*1000;
}
- (NSTimeInterval)changeTimeIntervalYYMMDDHH{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [f dateFromString:self];
    return [date  timeIntervalSince1970]*1000;
}

- (NSTimeInterval)changeTimeIntervalYYMMDD{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [f dateFromString:self];
    return [date  timeIntervalSince1970]*1000;

}

- (NSString *)encodeString{
    if (!self || self.length < 1 ) {
     return @"";
    }
    
    return [[self disable_emoji]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)disable_emoji
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (BOOL)isContainsEmoji{
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
- (BOOL)cheackNUll{
    
    if (!self || [self isEqualToString:@""] || self.length <1) {
        return YES;
    }
    return NO;
}
@end


