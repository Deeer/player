//
//  DeeTableViewController.m
//  播放器
//
//  Created by Dee on 15/5/12.
//  Copyright (c) 2015年 zjsruxxxy7. All rights reserved.
//

#import "DeeTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Deevideos.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GDataXMLNode.h"

@interface DeeTableViewController ()<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableArray *videos;
@end

@implementation DeeTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //加载最新的视频信息
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/video?type=XML"];
    //用url生成一个request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    //异步
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (connectionError||data ==nil) {
            
            [MBProgressHUD showError:@"网络繁忙"];
            return ;
            
        }
        
       //解析json//解析方法系统自带 -
        //系统解析，返回字典
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //获取字典中 videos对应的元素
//        NSArray *videoArray = dic[@"videos"];
        //遍历数组中所有的字典 - （videos对应的也是一个字典）
//        for (NSDictionary *videoDic in videoArray) {
        //将数组放在模型中
//            Deevideos *model= [Deevideos videosWithDic:videoDic];
        //模型放在数组中
//            [self.videos addObject:model];
//        }
//        [self.tableView reloadData];
        
////=====================GData --createBy Google        
//        //解析xml数据--通过data数据得到根文档 --得到 Dom方式解析
//        GDataXMLDocument * doc = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];//代表整个文档
//        
//        //获得文档的根元素
//        GDataXMLElement *root = doc.rootElement;
//        NSLog(@"%@",root);
//        
//        //获得根元素的所有video元素
//        NSArray * element =[root elementsForName:@"video"];
//        
//        for (GDataXMLElement *videoElement in element) {
//            
//            Deevideos *video = [[Deevideos alloc]init];
//            //取出元素的属性
//        video.id =[videoElement attributeForName:@"id"].stringValue.intValue;
//        video.length =[videoElement attributeForName:@"length"].stringValue.intValue;
//        video.name =[videoElement attributeForName:@"name"].stringValue;
//        video.image =[videoElement attributeForName:@"image"].stringValue;
//        video.url =[videoElement attributeForName:@"url"].stringValue;
//            [self.videos addObject:video];
        
        //解析器
        NSXMLParser * parser =[[NSXMLParser  alloc]initWithData:data];
        
        //设置代理
        parser.delegate =self;
        
        //开始解析
        [parser parse];//同步执行，只有这步执行完才会执行下一步代码
        
        
        
        
        
        [self.tableView reloadData];
        
        
    }];
    
    
}
#pragma mark - parserDelegate
/**
 *  解析到元素的开头就会调用
 *
 *  @param parser        解析器
 *  @param elementName   元素名称
 *  @param namespaceURI  统一资源标识符
 *  @param qName         名称
 *  @param attributeDict 属性字典
 */
//每次只加载一行，字典中的属性都只是一行数据
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"------");
//    NSLog(@"%@",attributeDict);
//    NSLog(@"%@",elementName);
//    NSLog(@"_______");

    if([@"videos" isEqualToString:elementName]) return;
    
    NSLog(@"%@",attributeDict);
    Deevideos *video =[Deevideos videosWithDic:attributeDict];
    [self.videos addObject:video];
    
//    Deevideos *video = [[Deevideos alloc]init];
//    [self.videos addObject:video];
    
    
    
}

//解析到文档的开头
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"document start");
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"document end");
}

#pragma mark - lazy
-(NSMutableArray *)videos
{
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"aaaaaaa");
    // Configure the cell...
    static NSString *ID =@"player";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Deevideos *video = self.videos[indexPath.row];
    
    cell.textLabel.text = video.name;
    
    cell.detailTextLabel.text=  [NSString stringWithFormat:@":%d MIN",video.length];
    
    NSString*imgurl =[NSString stringWithFormat:@"http://localhost:8080/MJServer/%@",video.image];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"placehoder2"]];
    
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deevideos *video = self.videos[indexPath.row];
    [MBProgressHUD showSuccess:video.name];
    
    
    //直接显示系统自带的视频播放控制器
    NSString *path =[NSString stringWithFormat:@"http://localhost:8080/MJServer/%@",video.url];
    NSURL *url =[NSURL URLWithString:path];
    MPMoviePlayerViewController * player= [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    
    //显示播放器
    [self presentMoviePlayerViewControllerAnimated:player];
    
    
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
