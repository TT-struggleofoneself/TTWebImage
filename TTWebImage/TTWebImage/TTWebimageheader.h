//
//  TTWebimageheader.h
//  TTWebImage
//
//  Created by TT_code on 16/5/3.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#ifndef TTWebimageheader_h
#define TTWebimageheader_h




/************单例************/
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





#endif /* TTWebimageheader_h */
