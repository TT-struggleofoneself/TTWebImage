//
//  TTDownFileManager.h
//  05-掌握-大文件下载
//
//  Created by TT_code on 16/5/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//'

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


/**
 *  下载进度block
 */
typedef void (^downfileProgress) (CGFloat progress);

/**
 *  下载完成Block
 *
 */
typedef void (^downfileComplete) (NSError *error,NSString* filepath);



@interface TTDownFileManager : NSObject
singleton_interface(TTDownFileManager)





-(void)Downloadurl:(NSString*)url   progress:(downfileProgress)newprogress    complete:(downfileComplete)complete;


@end
