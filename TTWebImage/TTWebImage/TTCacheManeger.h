//
//  TTDownFile.h
//  TTWebImage
//
//  Created by TT_code on 16/5/3.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTWebimageheader.h"
#import <UIKit/UIKit.h>


@interface TTCacheManeger : NSObject

/// 单例创建
singleton_interface(TTCacheManeger)

/** *图片字典  */
@property(nonatomic,strong)NSMutableDictionary* images;

/** *子线程字典  */
@property(nonatomic,strong)NSMutableDictionary* operations;


/** 队列对象 */
@property (nonatomic, strong) NSOperationQueue *queue;


/**
 *  清空所有内存
 */
- (void)clearMemory;


/**
 *  取消所有下载
 */
- (void)cancelAll ;

@end
