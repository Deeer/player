//
//  Deevideos.m
//  播放器
//
//  Created by Dee on 15/5/12.
//  Copyright (c) 2015年 zjsruxxxy7. All rights reserved.
//

#import "Deevideos.h"

@implementation Deevideos
+(instancetype)videosWithDic:(NSDictionary *)dic
{
    Deevideos *vides =[[self alloc]init];
    [vides setValuesForKeysWithDictionary:dic];
    return vides;
}
@end
