//
//  TTDownFileManager.m
//  05-掌握-大文件下载
//
//  Created by TT_code on 16/5/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "TTDownFileManager.h"
#import <UIKit/UIKit.h>
#import "NSString+Hash.h"


// 存储文件总长度的文件路径（caches）
#define XMGTotalLengthFullpath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.xmg"]


@interface TTDownFileManager() <NSURLSessionDataDelegate>
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/** session */
@property (nonatomic, strong) NSURLSession *session;
/** 写文件的流对象 */
@property (nonatomic, strong) NSOutputStream *stream;
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger totalLength;

/** 下载文件路径 */
@property(nonatomic,strong)NSString* downfilePath;

/** 下载文件路径 */
@property(nonatomic,strong)NSString* downfileName;

/** 保存文件路径 */
@property(nonatomic,strong)NSString* holdFileFullpath;

/** 已经下载的文件长度 */
@property(nonatomic,assign)NSInteger alreadydownloadLength;

/** 当前进度block */
@property(nonatomic,copy)downfileProgress currentprogress;

/** 文件下载完成block */
@property(nonatomic,copy)downfileComplete completeblock;

@end

@implementation TTDownFileManager

singleton_implementation(TTDownFileManager)

/**
 *  懒加载
 *
 */
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (NSOutputStream *)stream
{
    if (!_stream) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.holdFileFullpath append:YES];
    }
    return _stream;
}

- (NSURLSessionDataTask *)task
{
    if (!_task) {
        NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:XMGTotalLengthFullpath][self.downfileName] integerValue];
        if (totalLength && self.alreadydownloadLength == totalLength) {
            NSLog(@"----文件已经下载过了");
            return nil;
        }
        // 创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.downfilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        
        
        // 设置请求头
        // Range : bytes=xxx-xxx
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.alreadydownloadLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        // 创建一个Data任务
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}



-(void)Downloadurl:(NSString*)url   progress:(downfileProgress)newprogress    complete:(downfileComplete)complete
{
    //判断下载路径是否为空
    if(url.length==0){
        NSLog(@"下载路径为空");
        return;
    }
    //1.赋值--下载路径 2. 下载名称  3. 保存地址
    self.downfilePath=url;
    NSArray* array=[url componentsSeparatedByString:@"."];
    self.downfileName=self.downfilePath.md5String;
    
    
    NSString* downfilepath=self.downfileName;
    if(array.count>0){
       downfilepath=[downfilepath stringByAppendingString:[NSString stringWithFormat:@".%@",(NSString*)[array lastObject]]];
    }
    
    self.holdFileFullpath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downfilepath];

    //已经下载的文件长度
    self.alreadydownloadLength=[[[NSFileManager defaultManager] attributesOfItemAtPath:self.holdFileFullpath error:nil][NSFileSize] integerValue];
    
    //监听 block
    self.currentprogress=^(CGFloat progress){
        newprogress(progress);
    };
    
    //监听完成block
    self.completeblock=^(NSError *error,NSString* filepath){
        complete(error,filepath);
    };
    
    
    // 启动任务
    [self.task resume];
}


#pragma mark - <NSURLSessionDataDelegate>
/**
 * 1.接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 打开流
    [self.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + self.alreadydownloadLength;
    
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:XMGTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[self.downfileName] = @(self.totalLength);
    [dict writeToFile:XMGTotalLengthFullpath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 2.接收到服务器返回的数据（这个方法可能会被调用N次）
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //已经下载的文件长度
    self.alreadydownloadLength=[[[NSFileManager defaultManager] attributesOfItemAtPath:self.holdFileFullpath error:nil][NSFileSize] integerValue];
    
    
    // 写入数据
    [self.stream write:data.bytes maxLength:data.length];
    //NSLog(@"打印下值:%ld,  %ld,",self.alreadydownloadLength,self.totalLength);
    self.currentprogress(1.0 * self.alreadydownloadLength / self.totalLength);
    
//    // 下载进度
    NSLog(@"当前文件下载进度: %f", 1.0 * self.alreadydownloadLength / self.totalLength);
}

/**
 * 3.请求完毕（成功\失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error){
        NSLog(@"下载文件错误信息:%@",error);
    }
   
    // 关闭流  // 清除任务
    [self.stream close];
    self.stream = nil;
    self.task = nil;
    //完成block
    self.completeblock(error,self.holdFileFullpath);
}




@end
