//
//  UIImageView+TTImage.m
//  TTWebImage
//
//  Created by TT_code on 16/5/3.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import "UIImageView+TTWebCache.h"
#import "TTCacheManeger.h"

@implementation UIImageView (TTWebCache)

-(void)TTWebimageurl:(NSString*)url   placeholder:(UIImage*)placeholder
{
    self.image=placeholder;
    // 获得Library/Caches文件夹
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    // 获得文件名
    NSString *filename = [url lastPathComponent];
    // 计算出文件的全路径
    NSString *file = [cachesPath stringByAppendingPathComponent:filename];
    // 加载沙盒的文件数据
    NSData *data = [NSData dataWithContentsOfFile:file];
    
    if(!data){//如果没有缓存需要下载
        NSOperation* operation=[TTCacheManeger sharedTTCacheManeger].operations[url];
        //判断子线程是否存在
        if(!operation){
            operation=[NSBlockOperation blockOperationWithBlock:^{
                // 下载图片
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                if(!data){
                    [[TTCacheManeger sharedTTCacheManeger].operations removeObjectForKey:url];
                    return  ;
                }
                UIImage* newimage=[UIImage imageWithData:data];
                //保存图片到内存中
                [TTCacheManeger sharedTTCacheManeger].images[url]=newimage;
                //回到主线程修改图片
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //设置值
                    self.image=newimage;
                   // [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                //将图片缓存到本地
                // 将图片文件数据写入沙盒中
                [data writeToFile:file atomically:YES];
                // 移除操作
                [[TTCacheManeger sharedTTCacheManeger].operations removeObjectForKey:url];
            }];
            // 添加到队列中
            [[TTCacheManeger sharedTTCacheManeger].queue addOperation:operation];
            // 存放到字典中
            [TTCacheManeger sharedTTCacheManeger].operations[url] = operation;
        }
    }else{
        [TTCacheManeger sharedTTCacheManeger].images[url]=[UIImage imageWithData:data];
        self.image=[TTCacheManeger sharedTTCacheManeger].images[url];
    }
}



@end
