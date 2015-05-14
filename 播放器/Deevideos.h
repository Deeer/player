//
//  Deevideos.h
//  播放器
//
//  Created by Dee on 15/5/12.
//  Copyright (c) 2015年 zjsruxxxy7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deevideos : NSObject
@property (nonatomic,assign)int id;
@property (nonatomic,assign)int length;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *url;

+(instancetype)videosWithDic:(NSDictionary *)dic;

@end
