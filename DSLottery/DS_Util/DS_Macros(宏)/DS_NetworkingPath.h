//
//  DS_NetworkingPath.h
//  DSLottery
//
//  Created by 黄玉洲 on 2018/4/26.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#ifndef DS_NetworkingPath_h
#define DS_NetworkingPath_h

//百度地图
#define mapKey @"7j42VAGV7wnpOtr2AtRX3HMNqH9Iaxmm"

//#define  URLHTTP  @"http://a.facai8.cc:8080/api/"   //服务器域名
#define  URLHTTP  @"http://api.aa.77.nf/"             //服务器域名

#define  COMPANYSHORTNAME  @"AA"                    //公司名称
#define  CLIENTTYPE  @"IOS"                         //客户端平台
#define  APPVERSION  @"4"                           //版本
//#define  IMGURL      @"http://a.facai8.cc:8080/api/image/" //图片链接
#define  IMGURL      @"http://api.aa.77.nf/image/" //图片链接
/* 注册 */
static NSString * const REGISTER = @"member/register.json";

/* 登录 */
static NSString * const LOGIN = @"member/login.json";

/* 用户注销 */
static NSString * const SIGOUT = @"member/sigout.json";

/* 修改登录密码 */
static NSString * const RESETPASSWORD = @"member/resetPassword.json";

/* 编辑用户信息 */
static NSString * const EDITUSERINFO = @"member/editUserInfo.json";

/* 获取验证码 */
static NSString * const GETCODE = @"code/getCode.json";

/* 检验验证码 */
static NSString * const CHECKCODE = @"code/checkCode.json";

/* 用户名是否唯一 */
static NSString * const GETACCOUNTUNIQUEFLAG = @"member/getAccountUniqueFlag.json";

/* 获取用户SESSION信息 */
static NSString * const GETUSERSESSION = @"member/getUserSession.json";

/* 获取客服链接 */
static NSString * const GETKEFU = @"webSetting/getKefu.json";

/* 获取开奖公告列表 */
static NSString * const GETALLSSCDATA = @"ssc/getAllSscData.json";

/* 获取开奖信息列表 */
static NSString * const GETHISTORY = @"ssc/getHistory.json";

/* 获取彩票开奖信息-IOS */
static NSString * const GETSSCTIMEDATA = @"ssc/getSscTimeData.json";

/* APP资讯 */
static NSString * const GETAPPNEWS = @"msg/getAppNews.json";

/** 点赞资讯 */
static NSString * const SUPPORT_NEWS = @"msg/subThumbsUp.json";

/** 阅读资讯 */
static NSString * const READ_NEWS = @"msg/readNews.json";

/* 广告列表  */
static NSString * const GET_ADVERT_LIST = @"advertisement/getAdvertisement.json";
//static NSString * const GETADVERTISEMENT = @"advertisement/getCurlAd.json";

/* 公告栏 */
static NSString * const NOTICI = @"notice/getNotice.json";

/* 点击广告 */
static NSString * const CLICKADVERTISEMENT = @"advertisement/clickAdvertisement.json";

/* 获得图片资源 */
static NSString * const GETIMAGEDATA = @"image/getImageData.json";

/* 服务器时间接口 */
static NSString * const GETSERVERTIME = @"time/getServerTime.json";

/* APP安装首次调用 */
static NSString * const INSTALLFISRTINVOKE = @"app/installFisrtInvoke.json";

/* 添加通讯录 */
static NSString * const SETCOMMLIST = @"app/setCommList.json";

/* 获取最新版本号 */
static NSString * const GETAPPGENXIN = @"app/getAppGenxin.json";

/* 检查IP[区域限制] */
static NSString * const CHECKIP = @"app/checkIp.json";

/*游戏说明*/
static NSString * const WEBSETTING = @"webSetting/getGameInfo.json";

/** 类别（资讯分类、地区分类） */
static NSString * const CATEGORYS = @"msg/getAppNewsCatogory.json";

#endif /* DS_NetworkingPath_h */
