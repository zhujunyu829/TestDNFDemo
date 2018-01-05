//
//  AppMacro.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString             stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#define APPDBPATH  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"DNFData.db"]

/**
 空代码块
 */
typedef void(^voidBlock) ();
/**
 *系统版本
 */
#define SystemVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

//当前设备的屏幕宽度
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
//当前设备的屏幕高度
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#endif /* AppMacro_h */
