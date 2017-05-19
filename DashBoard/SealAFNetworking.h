//
//  SealAFNetworking.h
//  AFnetworking-Test
//
//  Created by totyu3 on 16/8/19.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum {//枚举请求地址种类
    
    ZwloginType,
    ZwgetFacilityList,//新接口
    ZwgetbuildinginfoType,
    ZwgetcustlistType,
    ZwgetalertinfoType,
    
    //颜色选择
    ZwgetcolorinfoType,
    
    //可视化设定
    ZwgetvzconfiginfoType,
    ZwgetupdatevzconfiginfoType,
    ZwupdateactioncolorType,
    ZwupdatenoticeType,
    
    //通知一览
    ZwgetvznoticeinfoType,
    ZwgetvznoticecountType,
    
    //图表
    WeeklylrinfoType,
    LrinfoType,
    LrsuminfoType
    
}NITPostUrlType;

@interface SealAFNetworking : NSObject
/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
+(SealAFNetworking *)NIT;
/**
 *  POST请求
 *
 *  @param URLtype    请求地址
 *  @param parameters 提交接口数据
 *  @param mjheader   mjheader - 用于在接口调用完毕后隐藏下拉刷新
 *  @param selfview   调用af接口的view - 用于隐藏hud
 *  @param success    请求成功回调
 *  @param defeats    请求失败回调
 */
- (void)PostWithUrl:(NITPostUrlType)URLtype
         parameters:(id)parameters
           mjheader:(id)mjheader
          superview:(id)selfview
            success:(void (^)(id))success
            defeats:(void (^)(NSError *))defeats;

-(void)requestCancel;

@end











