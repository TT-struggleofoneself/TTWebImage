//
//  TTDownFile.m
//  TTWebImage
//
//  Created by TT_code on 16/5/3.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import "TTCacheManeger.h"



@implementation TTCacheManeger

singleton_implementation(TTCacheManeger)
/**
 *  队列懒加载
 *
 */
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;//设置队列最大并发数
    }
    return _queue;
}

/**
 *  懒加载
 */
-(NSMutableDictionary *)images
{
    if(!_images){
        _images=[NSMutableDictionary dictionary];
    }
    return _images;
}

/**
 *  懒加载
 */
-(NSMutableDictionary *)operations
{
    if(!_operations){
        _operations=[NSMutableDictionary dictionary];
    }
    return _operations;
}




/**
 *  取消所有下载
 */
- (void)cancelAll {
    @synchronized ([TTCacheManeger sharedTTCacheManeger].operations) {
        NSMutableArray* mutablearray=[NSMutableArray array];
        //拼接请求地址:
        NSArray* allkey=[TTCacheManeger sharedTTCacheManeger].operations.allKeys;
        for (int i=0; i<[TTCacheManeger sharedTTCacheManeger].operations.count; i++) {
            NSString* key=allkey[i];
            NSOperation* operation=[[TTCacheManeger sharedTTCacheManeger].operations valueForKey:key];
            [mutablearray addObject:operation];
        }
        [mutablearray makeObjectsPerformSelector:@selector(cancel)];
        [mutablearray removeAllObjects];
    }
}



/**
 *  清空所有内存
 */
- (void)clearMemory {
    [TTCacheManeger sharedTTCacheManeger].images=[NSMutableDictionary dictionary];
    
    
    
    
}


@end
