//
//  TableviewVC.m
//  TTWebImage
//
//  Created by TT_code on 16/4/29.
//  Copyright © 2016年 TT_code. All rights reserved.
//

#import "TableviewVC.h"
#import "TTApp.h"
#import "UIImageView+TTWebCache.h"

@interface TableviewVC ()

/** *数据源  */
@property(nonatomic,strong)NSMutableArray* dataarray;



@end

@implementation TableviewVC




static NSString* idetifier=@"mycell";
/**
 *  懒加载
 */
-(NSMutableArray *)dataarray
{
    if(!_dataarray){
        _dataarray=[NSMutableArray array];
        NSArray* dictarray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
        for (NSDictionary *dict in dictarray) {
            [_dataarray addObject:[TTApp appWithDict:dict]];
        }
    }
    return _dataarray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //基础设置
    self.title=@"缓存图片";
    
    
    //点击按钮下载文件
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下载文件" style:UIBarButtonItemStylePlain target:self action:@selector(DownFile)];
}


//模仿  sdwebimage  做的一个下载图片和下载文件的功能----其中下载图片有缓存到内存和沙盒中  下载文件有缓存到沙盒中  并且下载中途断开之后下次会继续下载--并且下载的文件不同 文件名也会不同。（MD5加密取名）
-(void)DownFile
{
    [[TTDownFileManager sharedTTDownFileManager] Downloadurl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" progress:^(CGFloat progress) {
        NSLog(@"打印下当前的下载进度:%f",progress);
    } complete:^(NSError *error, NSString *filepath) {
        NSLog(@"打印下下载完成之后的路径:%@",filepath);
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"下载完成" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}


#pragma mark-tableview  delegate-or-datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:idetifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    //加载图片
    TTApp* dao=self.dataarray[indexPath.row];
    cell.textLabel.text=dao.name;
    cell.detailTextLabel.text=dao.download;
    
    //设置默认图片
    [cell.imageView TTWebimageurl:dao.icon placeholder:[UIImage imageNamed:@"placeholder"]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


///**
// *  内存警告
// */
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    
//    self.images = nil;
//    self.operations = nil;
//    [self.queue cancelAllOperations];
//}


@end
