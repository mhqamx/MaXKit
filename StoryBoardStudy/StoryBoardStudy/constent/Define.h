//
//  Define.h
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark - 颜色相关
#define RGBA(r, g, b, a)            [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:a]
#define RGB(r, g, b)                RGBA(r, g, b, 1.f)

#pragma mark - 屏幕相关
#define SCREEN_BOUNDS               ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

//分辨率
#define SCREEN_RESOLUTION_WIDTH     (SCREEN_WIDTH * [UIScreen mainScreen].scale)
#define SCREEN_RESOLUTION_HEIGHT    (SCREEN_HEIGHT * [UIScreen mainScreen].scale)

//尺寸比例
#define HEIGHT_SCALE_BASE_ON_736(h) (SCREEN_HEIGHT * h / 736)
#define WIDTH_SCALE_BASE_ON_414(w)  (SCREEN_WIDTH * w / 414)
#define HEIGHT_SCALE_BASE_ON_667(h) (SCREEN_HEIGHT * h / 667)
#define WIDTH_SCALE_BASE_ON_375(w)  (SCREEN_WIDTH * w / 375)

#define IPHONE_896  (SCREEN_HEIGHT == 896)
#define IPHONE_812  (SCREEN_HEIGHT == 812)
#define IPHONE_736  (SCREEN_HEIGHT == 736)
#define IPHONE_667  (SCREEN_HEIGHT == 667)
#define IPHONE_568  (SCREEN_HEIGHT == 568)
#define IPHONE_480  (SCREEN_HEIGHT == 480)


#define APP_COLOR_TABBAR_TITLE              RGB(195.f, 195.f, 195.f)
#define APP_COLOR_TABBAR_TITLE_HIGHLIGHT    RGB(51.f, 51.f, 51.f)



#pragma mark - 字体相关
#define APPFONT(fn, fs)                         [UIFont fontWithName:fn size:(fs)]

//默认字体
#define HELVETICA(fs)                           APPFONT(@"Helvetica", fs)
#define HELVETICABOLD(fs)                       APPFONT(@"Helvetica-Bold", fs)

#define APP_FONT_TABBAR_TITLE                   HELVETICA(12.f)
#define APP_FONT_TABBAR_TITLE_HIGHLIGHT         HELVETICA(12.f)

#define CHATCONTENT_MAXWIDTH        SCREEN_WIDTH - 50

#endif /* Define_h */
