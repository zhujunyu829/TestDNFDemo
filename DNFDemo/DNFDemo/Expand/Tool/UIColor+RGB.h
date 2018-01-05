//
//  UIColor+RGB.h
//  dayCRM
//
//  Created by sam on 14-11-20.
//  Copyright (c) 2014年 dayHR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha:(CGFloat)alpha;
@end
