//
//  TTApp.m
//  TTWebImage
//
//  Created by TT_code on 16/4/29.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import "TTApp.h"

@implementation TTApp

+ (instancetype)appWithDict:(NSDictionary *)dict
{
    TTApp *app = [[self alloc] init];
    [app setValuesForKeysWithDictionary:dict];
    return app;
}






@end
