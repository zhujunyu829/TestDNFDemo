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

#endif /* AppMacro_h */
