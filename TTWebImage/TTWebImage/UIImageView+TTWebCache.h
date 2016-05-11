//
//  UIImageView+TTImage.h
//  TTWebImage
//
//  Created by TT_code on 16/5/3.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDownFileManager.h"


@interface UIImageView (TTWebCache)


/**
 *  加载图片
 *
 *  @param url         url 路径
 *  @param placeholder 默认图片
 */
-(void)TTWebimageurl:(NSString*)url   placeholder:(UIImage*)placeholder;




@end
