//
//  TTApp.h
//  TTWebImage
//
//  Created by TT_code on 16/4/29.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTApp : NSObject


/** 图标 */
@property (nonatomic, strong) NSString *icon;
/** 下载量 */
@property (nonatomic, strong) NSString *download;
/** 名字 */
@property (nonatomic, strong) NSString *name;

+ (instancetype)appWithDict:(NSDictionary *)dict;


@end
