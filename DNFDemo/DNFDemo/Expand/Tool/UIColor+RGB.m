//
//  UIColor+RGB.m
//  dayCRM
//
//  Created by sam on 14-11-20.
//  Copyright (c) 2014年 dayHR. All rights reserved.
//

#import "UIColor+RGB.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (RGB)


+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    return [UIColor colorWithHexString:stringToConvert withAlpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha:(CGFloat)alpha{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];

}
@end
