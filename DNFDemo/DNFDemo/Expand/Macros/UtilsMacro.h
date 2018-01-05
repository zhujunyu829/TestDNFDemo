//
//  UtilsMacro.h
//  DNFDemo
//
//  Created by ZhuJunyu on 2017/4/12.
//  Copyright © 2017年 ZhuJunyu. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

/**
 *颜色值 RGB转uicolor
 */
#define RGB(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

/**
 *颜色值 十六进制转换成uicolor
 */
#define ColorHex(hexValue) [UIColor colorWithHexString:hexValue]

#endif /* UtilsMacro_h */
