//
//  NSString+CheakSize.h
//  DayHr
//
//  Created by sam on 14-7-17.
//  Copyright (c) 2014年 DayHR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CheakSize)

/*
 金钱格式
 */

+ (NSString *)moneyStringFormFloat:(double)value;
- (float)floatValueFromMoney;
+ (NSString *)changeTime:(id)time;
- (NSDate *)dateFormeString;
/**
 *  获取字符串长度
 *
 *  @param font 字体
 *  @param size
 *
 *  @return 返回字符串需要的size
 */
- (CGSize)sizeForStringwithFont:(UIFont *)font andSize:(CGSize)size;
/**
 *  将yyyy－mm－dd 转换成yyyy年mm月dd日
 */
- (NSString *)changeDate;
/**
 *  返回到分的时间格式
 *
 *  @return 2014年09月14日 17:00
 */
- (NSString *)changeDateDDYYMMSS;
/**
 *返回时间戳  "yyyy-MM-dd“
 *@return 返回时间戳
 */

- (NSTimeInterval)changeTimeIntervalYYMMDD;
/**
 *返回时间戳  "yyyy-MM-dd hh:mm“
 *@return 返回时间戳
 */

- (NSTimeInterval)changeTimeIntervalYYMMDDHH;
/**
 *返回时间戳  "yyyy-MM-dd HH:mm:ss“
 *@return 返回时间戳
 */
- (NSTimeInterval)changeTimeInterval;
/**
 *  返回时间差
 *
 *  @return 时间差
 */
- (NSString *)calculateDate;
/**
 *  返回完成的状态
 *
 *  @param finshTime 完成时的时间字符串
 *
 *  @return 返回结果
 */
- (NSString *)compleFinshTime:(NSString *)finshTime;


/**
 *判断是否含有表情
 *@return 返回bool值
 */

- (BOOL)isContainsEmoji;
/**
 *清除表情
 *@return 返回没有表情的字符串
 */
- (NSString *)disable_emoji;



/*
 *返回utf-8编码
 *
 *  @return 返回utf-8编码
 */
- (NSString *)encodeString;

- (BOOL)cheackNUll;
/*
 *
 *返回小数点后几位的字符串
 *
 */
+(NSString *)notRounding:(double)price afterPoint:(int)position;
@end
