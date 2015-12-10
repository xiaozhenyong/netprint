//
//  DefineData.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#ifndef NetPrint_IOS_DefineData_h
#define NetPrint_IOS_DefineData_h

#define USERNAME @"xiao11"
#define PWD @"111111"

#define  PHOTO_SIZE @"PhotoSize"
#define  PHOTO_TEXTURE @"PhotoTexture"
#define  GOODS @"Goods"


#define VERSION @"phoneversion2015-06-2615:33:50"


#define BASE_URL  @"http://192.168.1.228:8080/platform/"
#define PHONE_LOGIN  @"http://192.168.1.228:8080/platform/phone/phone_login.do"
#define PHONE_ORDER_SETTLE @"http://192.168.1.228:8080/platform/phone/phone_order_settle.do"//结算或者使用优惠券
//#define PHONE_PHOTOS_DETAIL @"http://192.168.1.228:8080/platform/shop/get_Phone_Photos_Detail.do?versionNumber=%@"//用户数据版本的验证
#define PHONE_PHOTOS_DETAIL @"http://192.168.1.228:8080/platform/shop/get_Phone_Photos_Detail.do"//用户数据版本的验证
#define PHONE_ADDRES @"http://192.168.1.228:8080/platform/phone/phone_addrs.do"//行政地址
#define PHONE_ADDR_UPDATE @"http://192.168.1.228:8080/platform/phone/phone_addr_update.do"//修改地址
#define PHONE_UPLOAD_PHOTO @"http://192.168.1.228:8080/platform/phone/phone_upload_photo.do"//购物车 图片上传
#define PHONE_ORDER_SUBMIT @"http://192.168.1.228:8080/platform/phone/phone_order_submit.do"//提交订单
#define PHONE_LOGIN @"http://192.168.1.228:8080/platform/phone/phone_login.do"//用户登录
#define REGIST @"http://192.168.1.228:8080/platform/phone/regist.do"//用户注册
#define PHONE_ORDER_DETAIL @"http://192.168.1.228:8080/platform/phone/phone_order_detail.do"//
#define PHONE_MEMBER_MONEY @"http://192.168.1.228:8080/platform/phone/phone_member_money.do"//我的账户余额
#define PHONE_MEMBER_COUPONS @"http://192.168.1.228:8080/platform/phone/phone_member_coupons.do"//我的优惠券
#define PHONE_CHANGE_PWD @"http://192.168.1.228:8080/platform/phone/phone_change_pwd.do"//
#define PHONE_SEND_CODE @"http://192.168.1.228:8080/platform/phone/phone_send_code.do"//
#define PHONE_FIND_PWD @"http://192.168.1.228:8080/platform/phone/phone_find_pwd.do"//用户找回密码
#define PHONE_SET_PWD @"http://192.168.1.228:8080/platform/phone/phone_set_pwd.do"//修改登录密码
#define PHONE_HELP @"http://192.168.1.228:8080/platform/phone/phone_help.do"//用户获取帮助信息
#define PHONE_MEMBER_ORDERS @"http://192.168.1.228:8080/platform/phone/phone_member_orders.do"//用户订单
#define PHONE_RECHARGE @"http://192.168.1.228:8080/platform/phone/phone_recharge.do"//用户充值
#define PAY_USED_REMAINING @"http://192.168.1.228:8080/platform/phone/pay_used_remaining.do"//余额支付
#define PHONE_SIZEPRICE @"http://192.168.1.228:8080/platform/phone/phone_sizeprice.do" //照片尺寸价格
#define PHONE_SET_PAYPWD @"http://192.168.1.228:8080/platform/phone/phone_set_paypwd.do" //设置支付密码
#define PHONE_USER_ENTER @"http://192.168.1.228:8080/platform/phone/phone_user_enter.do" //用户第一次进入
#define PHONE_GET_CODE @"http://192.168.1.228:8080/platform/phone/phone_get_code.do" //获取验证码
//普通冲印方式
#define  WRAP_P @"5858"

//塑封冲印方式
#define  WRAP_S @"5859"
#endif
