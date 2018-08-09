//
//  App_ZLZ_Helper.m
//  融通天下
//
//  Created by MyApple on 13/03/2018.
//  Copyright © 2018 坤亚. All rights reserved.
//

#import "App_ZLZ_Helper.h"
//#import "PersonInfoViewController.h"
//#import "LoginViewController.h"
//#import "FaceParameterConfig.h"
//#import "PWKeyboardView.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation App_ZLZ_Helper

App_ZLZ_Helper * app_zlz_helper = nil;

+ (App_ZLZ_Helper *)getHelper {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        app_zlz_helper = [[App_ZLZ_Helper alloc] init];
        app_zlz_helper.carsARR = @[];
        app_zlz_helper.carsInexARR = @[];
    });

    return app_zlz_helper;
}

- (NSString *)getServiceStr
{
    return SERVICE;
}
- (NSString *)getRootImageUrlStr
{
    return IMAGEURL;
}

- (NSString *)getFACE_LICENSE_NAME
{
    return @"";
    //return FACE_LICENSE_NAME;
}
- (NSString *)getFACE_LICENSE_SUFFIX
{
    return @"";
    //return FACE_LICENSE_SUFFIX;
}
- (NSString *)getFACE_LICENSE_ID
{
    return @"";
    //return FACE_LICENSE_ID;
}

+ (int)getVERIFY_CODE_INTERVAL{
    return VERIFY_CODE_INTERVAL;
}

+ (NSDictionary *)getUSERINFO {
    GETUSERINFO
    return userInfo;
}

//根据省份证号获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr
{
    
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self birthdayStrFromIdentityCard:numberStr]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    NSLog(@"年龄%d",age);
    return [NSString stringWithFormat:@"%d",-age];
}
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //适用于18位
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
    
    //适用于15位
    
    //    //**截取前12位
    //    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];
    //
    //    //**检测前12位否全都是数字;
    //    const char *str = [fontNumer UTF8String];
    //    const char *p = str;
    //    while (*p!='\0') {
    //        if(!(*p>='0'&&*p<='9'))
    //            isAllNumber = NO;
    //        p++;
    //    }
    //    if(!isAllNumber)
    //        return result;
    //
    //
    //    year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(6, 2)]];
    //    month = [numberStr substringWithRange:NSMakeRange(8, 2)];
    //    day = [numberStr substringWithRange:NSMakeRange(10,2)];
    //
    //
    //    [result appendString:year];
    //    [result appendString:@"-"];
    //    [result appendString:month];
    //    [result appendString:@"-"];
    //    [result appendString:day];
    //    return result;
    
}

- (UIView *)addJinDuView:(NSArray *)dataArr index:(int)i useController:(UIViewController*)vc{
    //NSArray * arr = @[@"基本信息",@"资产信息",@"企业情况",@"企业财产",@"融资及资料"];
    //int index = 1;//第几步了
    NSArray * arr = dataArr;
    int index = i;
    CGFloat lineWidth = SCREENWidth/(arr.count + 1) - 30;
    UIView * topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:topView];
    [vc.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(vc.view);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(60);
    }];
    for (int i = 0; i < arr.count; i ++) {
        UILabel * label = [UILabel new];
        label.backgroundColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i+1];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 10;
        [topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(topView.mas_left).offset(SCREENWidth/(arr.count + 1)*(i+1));
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        UILabel * titlelabel = [UILabel new];
        titlelabel.text = arr[i];
        titlelabel.font = [UIFont systemFontOfSize:14];
        titlelabel.textColor = [UIColor darkGrayColor];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(label);
            make.top.mas_equalTo(label.mas_bottom).offset(5);
        }];
        if (i != (arr.count - 1)) {
            UIView * lineview = [UIView new];
            lineview.backgroundColor = [UIColor darkGrayColor];
            [topView addSubview:lineview];
            [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(label);
                make.left.mas_equalTo(label.mas_right).offset(5);
                make.width.mas_equalTo(lineWidth);
                make.height.mas_equalTo(1);
            }];
            if (i+1<=index) {
                lineview.backgroundColor = ZHUTICOLOR;
            }
        }
        if (i+1<=index) {
            label.backgroundColor = ZHUTICOLOR;
            titlelabel.textColor = ZHUTICOLOR;
        }
        
    }
    
    return topView;
}
+ (NSString *)getStringFromObj:(NSObject *)obj
{
    return [NSString stringWithFormat:@"%@", obj];
}

+ (BOOL)isBankCard:(NSString *)cardNo{
    
    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[cardNo length];
    NSInteger lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength -1];
    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) ==0)
        return YES;
    else
        return NO;
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    // 删除字符串中的空格
    NSString * colorStr = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([colorStr length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    // 除去所有开头字符后 再判断字符串长度
    if ([colorStr length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString * redStr = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString * greenStr = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString * blueStr = [colorStr substringWithRange:range];
    
    // Scan values 将十六进制转换成二进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

//获取订单信息并支付
+ (void)getOrderStrFromServerAndPayUseGoodsName:(NSString *)goodsName andGoodsPrice:(NSString*)goodsPrice andType:(NSString*)type andOrderId:(NSString *)orderId andPaySucessOrFailed:(void(^)(int))sucessOrFailedBlock{
    //提交数据
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"处理中...";
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/html",nil];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    GETUSERINFO
    [paramDict setValue:userInfo[@"id"] forKey:@"userId"];
    if (orderId != nil && orderId.length != 0) {
        [paramDict setValue:orderId forKey:@"id"];
    }else{
        [paramDict setValue:goodsName forKey:@"goodsName"];
        [paramDict setValue:goodsPrice forKey:@"goodsPrice"];
        [paramDict setValue:type forKey:@"type"];
    }
    [manager GET:[NSString stringWithFormat:@"%@alipays/goodsByAlipay.html",SERVICE] parameters:paramDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@获取订单信息成功返回:%@",task.currentRequest,responseObject);
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            
            NSString * orderStr = responseObject[@"data"] ;
            [App_ZLZ_Helper payUseAliPay:orderStr andResultCallBack:^(int result) {
                if(result == 1) {
                    //[MBProgressHUD showSuccess:@"支付成功！" toView:[UIApplication sharedApplication].keyWindow];
                    
                    //支付成功跳转
                    //XZD1ViewController * shenqing = [XZD1ViewController new];
                    //[self.navigationController pushViewController:shenqing animated:YES];
                    sucessOrFailedBlock(1);
                }else{
                    //[MBProgressHUD showSuccess:@"支付失败！" toView:[UIApplication sharedApplication].keyWindow];
                    sucessOrFailedBlock(2);
                }
            }];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow ];
            sucessOrFailedBlock(2);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@报错:%@",task.currentRequest,error);
        hud.hidden = YES;
        [MBProgressHUD showError:@"网络请求失败" toView:[UIApplication sharedApplication].keyWindow ];
        sucessOrFailedBlock(2);
    }];
}

////支付宝付款
+ (void)payUseAliPay:(NSString *)signOrderString andResultCallBack:(void(^)(int))callback
{
    NSString * scheme = [[NSBundle mainBundle] bundleIdentifier];
    [[AlipaySDK defaultService] payOrder:signOrderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSLog(@"pay reslut = %@",resultDic);
        NSString * memo = resultDic[@"memo"];
        NSLog(@"===memo:%@", memo);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {

            NSString * str = @"支付成功！";
            [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{

            }];
            callback(1);
        }else{
            NSString *resultStatus = resultDic[@"resultStatus"];
            NSString * str = @"";
            if ([resultStatus isEqualToString:@"9000"]) {

            }else if ([resultStatus isEqualToString:@"6002"])
            {
                str = @"网络连接出现错误！";
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{

                }];
            }
            else if ([resultStatus isEqualToString:@"8000"])
            {
                str = @"正在处理中！";
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{

                }];
            }
            else if ([resultStatus isEqualToString:@"4000"])
            {
                str = @"订单支付失败！";
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{

                }];
            }
            else if ([resultStatus isEqualToString:@"6001"])
            {
                str = @"您中途取消了支付！";
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{

                }];
            }

            callback(2);
        }
    }];
}
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
+(BOOL)isIphoneX{
    if (KIsiPhoneX) {
        return true;
    }else{
        return false;
    }
}
+(float)screenWidth
{
    return SCREENWidth;
}
+(float)screenHeight
{
    return SCREENHeight;
}

+ (void)sendDataToServerUseUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock {
    GETUSERINFO
    NSLog(@"===%@",userInfo);
    NSString * userId = @"";
    if (userInfo != nil) {
        userId = [NSString stringWithFormat:@"%@",userInfo[@"registerId"]];
    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = true;
    manager.responseSerializer = response;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSMutableDictionary * realDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [realDict setValue:userId forKey:@"userID"];
    MBProgressHUD * hud = nil;
    if (loadingTitle.length != 0) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
        hud.label.text = loadingTitle;
    }
    if (type == RequestType_Get) {
        [manager GET:[NSString stringWithFormat:@"%@%@",SERVICE,url] parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                
                if (sucessTitle.length != 0) {
                    [MBProgressHUD showSuccess:sucessTitle toView:[UIApplication sharedApplication].keyWindow];
                }
                successBlock(responseObject);
            }else{
                if (loadingTitle.length != 0){
                    //[MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                    [App_ZLZ_Helper showErrorMessageAlert:responseObject[@"msg"]];
                }
                
                failedBlock(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            if (loadingTitle.length != 0) {
                [MBProgressHUD showError:@"网络请求失败！"];
            }
        }];
    }else{
        [manager POST:[NSString stringWithFormat:@"%@%@",SERVICE,url] parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                
                if (sucessTitle.length != 0) {
                    [MBProgressHUD showSuccess:sucessTitle toView:[UIApplication sharedApplication].keyWindow];
                }
                successBlock(responseObject);
            }else{
                if (loadingTitle.length != 0){
                    //[MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                    [App_ZLZ_Helper showErrorMessageAlert:responseObject[@"msg"]];
                }
                
                failedBlock(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            if (loadingTitle.length != 0) {
                [MBProgressHUD showError:@"网络请求失败！"];
            }
        }];
    }

}

+ (void)sendImagesAndDataToServerUseUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock andImageArr:(NSArray *)imagesArr andFileName:(NSString *)fileNameKey
{
    MBProgressHUD * hud = nil;
    if (loadingTitle.length != 0) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
        hud.label.text = loadingTitle;
    }
    GETUSERINFO
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"userID"] = userInfo[@"registerId"];
    [dic setValuesForKeysWithDictionary:dict];

    NSLog(@"图片传入参数%@",dic);
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVICE,url] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        
        for (int i = 0; i < imagesArr.count; i++) {
            
            UIImage *image = imagesArr[i];
            //            NSData *imageData = UIImagePNGRepresentation(image);
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@%d.jpeg", dateString,i];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:fileNameKey fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度 NSProgress 配合KVC来使用 反应进度情况
        //[uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            
            if (sucessTitle.length != 0) {
                [MBProgressHUD showSuccess:sucessTitle toView:[UIApplication sharedApplication].keyWindow];
            }
            successBlock(responseObject);
        }else{
            if (sucessTitle.length != 0){
                //[MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                [App_ZLZ_Helper showErrorMessageAlert:responseObject[@"msg"]];
            }
            
            failedBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.hidden = YES;
        NSLog(@"%@报错:%@",task.currentRequest,error);
        hud.hidden = YES;
        failedBlock(error);
        [MBProgressHUD showError:@"网络请求失败！"];
    }];
}

+ (void)sendDataToServerUseUniqueUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = true;
    manager.responseSerializer = response;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSMutableDictionary * realDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    MBProgressHUD * hud = nil;
    if (loadingTitle.length != 0) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
        hud.label.text = loadingTitle;
    }
    if (type == RequestType_Get) {
        [manager GET:url parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            [MBProgressHUD showError:@"网络请求失败！"];
        }];
    }else{
        [manager POST:url parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            [MBProgressHUD showError:@"网络请求失败！"];
        }];
    }
    
}

+ (BOOL)valideUserInfoIsComplete:(UIViewController *)controller
{
    GETUSERINFO

    if (!userInfo) {
        //[controller.navigationController pushViewController:[LoginViewController new] animated:YES];
        return false;
    }
    
    NSString * userName = userInfo[@"userName"];
    if (userName.length != 0) {
        
        return true;
    }else{
        
        [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:@"请完善个人资料！" AndSureAction:^{
            //PersonInfoViewController * pivc = [[PersonInfoViewController alloc] init];
            //pivc.scanUrl = userInfo[@"invitationCodeImgUrl"];
            //[controller.navigationController pushViewController:pivc animated:true];
        }];
        return false;
    }
}

/*
 func sendDataToServer(url:String, dataDict:NSDictionary, type:Request_type, loadingTitle:String, sucessTitle:String, sucessBlock:@escaping ((NSDictionary)->()), filedBlock:@escaping((Error)->())){
 
 let userInfo = App_ZLZ_Helper.getHelper().getUSERINFO()
 let userId:String = "\(String(describing: (userInfo!["id"]!)))"
 let manager = AFHTTPSessionManager()
 let response = AFJSONResponseSerializer()
 response.removesKeysWithNullValues = true
 manager.responseSerializer = response
 let realDict = NSMutableDictionary.init(dictionary: dataDict)
 realDict.setValue(userId, forKey: "userId")
 
 let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
 hud.label.text = loadingTitle
 manager.get(App_ZLZ_Helper.getHelper().getServiceStr() + url, parameters: realDict, progress: { (progress) in
 
 }, success: { (task, responseObject) in
 hud.isHidden = true
 let dict = responseObject as! NSDictionary
 print((task.currentRequest?.url?.description)! + "返回数据 = \(dict)")
 if ("\(dict["status"]!)" == "1") {
 
 if sucessTitle.characters.count != 0 {
 MBProgressHUD.showSuccess(sucessTitle, to:UIApplication.shared.keyWindow)
 }
 
 sucessBlock(dict)
 
 }else{
 MBProgressHUD.showError(String(describing: dict["msg"]!), to:self.view)
 print("添加信用卡银行卡错误数据 = \(dict)")
 }
 }) { (task, error) in
 hud.isHidden = true
 MBProgressHUD.showError("网络请求失败", to:self.view)
 filedBlock(error)
 }
 }
 */

+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
+ (BOOL)valideRealName:(UIViewController *)controller andCancelBlock:(void(^)(void))cancelBlock andIsNeedPop:(BOOL)isPop
{
    GETUSERINFO
    NSString * isRealName = userInfo[@"isRealName"];
    if ([isRealName isEqualToString:@"1"]) {
        return true;
    }else{
        
        if (isPop) {
            
            [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:@"登录成功！您尚未实名认证，是否现在实名认证？" SureAction:^{
                
                UIViewController * vc = [controller.navigationController.viewControllers objectAtIndex:controller.navigationController.viewControllers.count - 2];
                [controller.navigationController popViewControllerAnimated:false];
                
                //查询缴费
                //请求接口是否支付
                [App_ZLZ_Helper sendDataToServerUseUrl:@"alipays/findByIsRealNameOrders.html" dataDict:@{} type:RequestType_Get loadingTitle:@"处理中..." sucessTitle:@"" sucessBlock:^(NSDictionary *responseObj) {
                    
                    [App_ZLZ_Helper getHelper].realNameComeViewController = vc;
                    //RealNameCerViewController * rncvc = [[RealNameCerViewController alloc] init];
                    //[vc.navigationController pushViewController:rncvc animated:true];
                } failedBlock:^(NSError *error) {
                    if (error == nil) {
                        [ChooseAlertView showChooseViewWithTitle:@"查询费用" ContentText:@"您需要支付本次实名认证查询费用0.99元" SureAction:^{
                            
                            [App_ZLZ_Helper  getOrderStrFromServerAndPayUseGoodsName:@"实名认证查询费用" andGoodsPrice:@"0.99" andType:@"3" andOrderId:@"" andPaySucessOrFailed:^(int a) {
                                
                            }];
                            
                        } AndCancelAction:^{
                            
                        }];
                    }else{
                        
                    }
                }];

            } AndCancelAction:^{
                cancelBlock();
            } SureTitle:@"去认证" CancelTitle:@"再等等"];
            return false;
        }
        
        [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:@"您尚未实名认证，是否现在实名认证？" SureAction:^{
            
            //查询缴费
            //请求接口是否支付
            [App_ZLZ_Helper sendDataToServerUseUrl:@"alipays/findByIsRealNameOrders.html" dataDict:@{} type:RequestType_Get loadingTitle:@"处理中..." sucessTitle:@"" sucessBlock:^(NSDictionary *responseObj) {
                
                [App_ZLZ_Helper getHelper].realNameComeViewController = controller;
                //RealNameCerViewController * rncvc = [[RealNameCerViewController alloc] init];
                //[controller.navigationController pushViewController:rncvc animated:true];
            } failedBlock:^(NSError *error) {
                if (error == nil) {
                    [ChooseAlertView showChooseViewWithTitle:@"查询费用" ContentText:@"您需要支付本次实名认证查询费用0.99元" SureAction:^{
                        
                        [App_ZLZ_Helper  getOrderStrFromServerAndPayUseGoodsName:@"实名认证查询费用" andGoodsPrice:@"0.99" andType:@"3" andOrderId:@"" andPaySucessOrFailed:^(int a) {
                            
                        }];
                        
                    } AndCancelAction:^{
                        
                    }];
                }else{
                    
                }
            }];
            
        } AndCancelAction:^{
            cancelBlock();
        } SureTitle:@"去认证" CancelTitle:@"再等等"];
        return false;
    }
}
+ (BOOL)valideRealName{
    GETUSERINFO
    NSString * isRealName = userInfo[@"isRealName"];
    if ([isRealName isEqualToString:@"1"]) {
        return true;
    }else{
        return false;
    }
}
+ (void)showValideRealNameView:(void(^)(void))sureBlock{
    
    [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:@"您尚未实名认证，是否现在认证？" AndSureAction:^{
        sureBlock();
        [ChooseAlertView showChooseViewWithTitle:@"查询费用" ContentText:@"您需要支付本次实名认证查询费用0.99元" SureAction:^{
            
            [App_ZLZ_Helper  getOrderStrFromServerAndPayUseGoodsName:@"查询费用" andGoodsPrice:@"0.99" andType:@"1" andOrderId:@"" andPaySucessOrFailed:^(int a) {
                
                sureBlock();
            }];
            /*
             //付款 跳转
             XZD1ViewController * shenqing = [XZD1ViewController new];
             [self.navigationController pushViewController:shenqing animated:YES];*/
        } AndCancelAction:^{
            
        }];
    }];
}

+ (void)sendDataToServerUseUrlTextHtmlContentType:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock {
    GETUSERINFO
    NSString * userId = [NSString stringWithFormat:@"%@",userInfo[@"id"]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = true;
    manager.responseSerializer = response;
    response.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary * realDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [realDict setValue:userId forKey:@"userId"];
    MBProgressHUD * hud = nil;
    if (loadingTitle.length != 0) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
        hud.label.text = loadingTitle;
    }
    if (type == RequestType_Get) {
        [manager GET:[NSString stringWithFormat:@"%@%@",SERVICE,url] parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                
                if (sucessTitle.length != 0) {
                    [MBProgressHUD showSuccess:sucessTitle toView:[UIApplication sharedApplication].keyWindow];
                }
                successBlock(responseObject);
            }else{
                if (sucessTitle.length != 0){
                    [MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                }
                
                failedBlock(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            [MBProgressHUD showError:@"网络请求失败！"];
        }];
    }else{
        [manager POST:[NSString stringWithFormat:@"%@%@",SERVICE,url] parameters:realDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                
                if (sucessTitle.length != 0) {
                    [MBProgressHUD showSuccess:sucessTitle toView:[UIApplication sharedApplication].keyWindow];
                }
                successBlock(responseObject);
            }else{
                if (sucessTitle.length != 0){
                    [MBProgressHUD showError:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                }
                
                failedBlock(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            failedBlock(error);
            [MBProgressHUD showError:@"网络请求失败！"];
        }];
    }
    
}
+ (BOOL)validePhoneNumber:(NSString *)phoneNumber{
    if (phoneNumber.length==11) {
        return true;
    }else{
        [CommonAlertView showAlertWithMessage:@"手机号格式错误！" AndTitle:@"温馨提示" Action:^{
            
        }];
        return false;
    }
}
+ (BOOL)valideCarNumber:(NSString *)carNumber{
    if (carNumber.length==7) {
        return true;
    }else{
        [CommonAlertView showAlertWithMessage:@"车牌号格式错误！" AndTitle:@"温馨提示" Action:^{
            
        }];
        return false;
    }
}
+ (CGFloat)labelLoadHtml:(NSString *)htmlStr andLabel:(UILabel *)label {
    //str是要显示的字符串
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    /*[attrString addAttributes:@{NSBaselineOffsetAttributeName: @(5),//设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏，可使UILabel文本垂直居中
                                NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, attrString.length)];*/
    
    label.attributedText = attrString;
    
    //计算html字符串高度
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, htmlString.length)];
    
    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){SCREENWidth - 40, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return textSize.height ;
}
+ (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent
{
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:100%;}</style>"];
    [strContent appendString:@"<style>video{width:100%;}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    [strContent appendString:@"<style>p{width:100%;}</style>"];
    return strContent;
}
+ (UIImage *)getImageFromScrollView:(UIScrollView *)scrollView
{
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
        
    scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);//currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
        
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
        
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)getImageFromUIView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);//currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();
    return image;
}
+ (UIColor*)getMainStyleColor{
    return ZHUTICOLOR;
}
+ (UIColor*)getCONTROLLERCOLOR {
    return CONTROLLERCOLOR;
}
//+ (UIColor *)getBaseControllerBackColor{
//    return MYGARYCOLOR;
//}

//显示删除loading
+ (void)showLoadingView:(NSString *)title
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
    hud.tag = 1902;
    hud.label.text = title;
}
+ (void)removeLoadingView
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:1902] removeFromSuperview];
}
    
+ (USER_TYPE)getUserType
{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    //1、用户 2、志愿者 3、商家 4、组织 5、咨询者
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"1"]) {
        return USER_TYPE_NORMAL;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"2"]) {
        return USER_TYPE_VOLUNTEER_CAR;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"3"]) {
        return USER_TYPE_BUSINESS;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"4"]) {
        return USER_TYPE_ORGANISE_MANAGEMENT;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"5"]) {
        return USER_TYPE_CONSULTANT;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"6"]) {
        return USER_TYPE_ORGANISE_NORMAL;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"identity"]] isEqualToString:@"7"]) {
        return USER_TYPE_VOLUNTEER_LOVE;
    }
    return USER_TYPE_NORMAL;
}
+ (BOOL)judgeUserType:(USER_TYPE)type{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString * str = [NSString stringWithFormat:@"%@",dic[@"identity"]];
    if (type == USER_TYPE_NORMAL) {
        if ([str containsString:@"1"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_VOLUNTEER_CAR){
        if ([str containsString:@"2"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_BUSINESS){
        if ([str containsString:@"3"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_ORGANISE_MANAGEMENT){
        if ([str containsString:@"4"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_CONSULTANT){
        if ([str containsString:@"5"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_ORGANISE_NORMAL){
        if ([str containsString:@"6"]) {
            return YES;
        }else{
            return NO;
        }
    }else if (type == USER_TYPE_VOLUNTEER_LOVE){
        if ([str containsString:@"7"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
//判断有无车辆信息
+ (void)isHaveCars:(void(^)(BOOL isHave))completeBlock{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"car/getVehiclemanagerByUserId.do" dataDict:@{} type:RequestType_Get loadingTitle:@"加载中..." sucessTitle:@"" sucessBlock:^(NSDictionary *responseObj) {
        if([responseObj[@"data"] count] != 0) {
            completeBlock(true);
        }else{
            completeBlock(false);
        }
    } failedBlock:^(NSError *error) {
        
    }];
}
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
}
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

+ (void)callPerson:(NSString *)phoneNumber andController:(UIViewController*)vc{
    if (phoneNumber.length == 0) {
        [MBProgressHUD showError:@"联系方式异常，无法呼叫！"];
        return;
    }
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phoneNumber];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:phoneNumber preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

//+ (void)showVehicalNumber:(UIViewController *)vc {
//    
//     __weak typeof (AddCarViewController*)weakSelf = vc;
//     weakSelf.carNumberTextField.inputView = [PWKeyboardView shareInstance];
//     [PWKeyboardView shareInstance].selectedColor = [UIColor greenColor];
//     [PWKeyboardView shareInstance].type = PWKeyBoardTypeCivilAndArmy;
//     [PWKeyboardView shareInstance].buttonClickBlock = ^(PWKeyboardButtonType buttonType, NSString *text) {
//     switch (buttonType) {
//     //当键位类型为确定时，收回键盘
//     case PWKeyboardButtonTypeDone:
//     [weakSelf.carNumberTextField resignFirstResponder];
//     break;
//     default:
//     //改变textField的text
//     [weakSelf.carNumberTextField changetext:text];
//     //将对应的改动传递给js，使键盘的刷新获取对应的键位
//     [[PWKeyboardView shareInstance] setPlate:weakSelf.carNumberTextField.text type:[PWKeyboardView shareInstance].type index:[weakSelf.carNumberTextField offsetFromPosition:weakSelf.carNumberTextField.beginningOfDocument toPosition:weakSelf.carNumberTextField.selectedTextRange.start]];
//     break;
//     }
//     };
//     
//}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 根据生日计算年龄
 */
+ (NSInteger)ageWithDateOfBirth:(NSString *)dateStr;
{
    if(![dateStr containsString:@"-"]){
        return 0;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date2=[dateFormatter dateFromString:[[dateStr componentsSeparatedByString:@"T"] firstObject]];
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date2];
    
    NSDateComponents * dateComponents1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];

    return [App_ZLZ_Helper getAgeFromTwoDateComponents:dateComponents andCurrentDate:dateComponents1];
}

+ (int)getAgeFromTwoDateComponents:(NSDateComponents *)dateComponents andCurrentDate:(NSDateComponents *)dateComponents1
{
    NSString * str = nil;
    if (dateComponents.month == dateComponents1.month) {
        
        if (dateComponents.day == dateComponents1.day) {
            
            str = [NSString stringWithFormat:@"%d", (dateComponents1.year - dateComponents.year)];
        }else{
            
            if (dateComponents.day > dateComponents1.day) {
                
                str = [NSString stringWithFormat:@"%d", (dateComponents1.year - dateComponents.year - 1)];
            }else{
                
                str = [NSString stringWithFormat:@"%d", (dateComponents1.year - dateComponents.year)];
            }
        }
    }else{
        
        if (dateComponents.month > dateComponents1.month) {
            
            str = [NSString stringWithFormat:@"%d", (dateComponents1.year - dateComponents.year - 1)];
        }else{
            
            str = [NSString stringWithFormat:@"%d", (dateComponents1.year - dateComponents.year)];
        }
    }
    
    return str.intValue;
}

+ (NSString *)getSafeString:(NSString *)str{
    if (str == nil) {
        return @"";
    }else{
        return str;
    }
}

+ (NSInteger)getRegisterDays:(NSString *)dateStr {
    if(![dateStr containsString:@"-"]){
        return 0;
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date2=[dateFormatter dateFromString:[[dateStr componentsSeparatedByString:@" "] firstObject]];
    
    return [date2 timeIntervalSinceNow]/3600/24 > 0 ? [date2 timeIntervalSinceNow]/3600/24 : -([date2 timeIntervalSinceNow]/3600/24);
}

+ (void)showErrorMessageAlert:(NSString *)message{
    [CommonAlertView showAlertWithMessage:message AndTitle:@"温馨提示" Action:^{
        
    }];
}
//该构造方法将时间戳转换为几分钟前/几小时前/几天前/几年前
//createTimeString为后台传过来的13位纯数字时间戳
+ (NSString *)updateTimeForRow:(NSString *)dateStr {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateStr];
    NSString * createTimeString = [NSString stringWithFormat:@"%f",[date2 timeIntervalSince1970]];
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize;
    
    //如果是IOS6.0
    if (![text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    //如果系统为iOS7.0
    　else
        　　{
            　　      // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
            labelSize = [text boundingRectWithSize: maxSize
                                           options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                        attributes:attributes
                                           context:nil].size;
        }
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}
+ (CGFloat)labelSingleRowWidth:(NSString *)text fontSize:(CGFloat)fontSize {
    UILabel * tempL = [[UILabel alloc] initWithFrame:CGRectZero];
    tempL.text = text;
    tempL.font = [UIFont systemFontOfSize:13];
    [tempL sizeToFit];
    return tempL.frame.size.width;
}

+ (NSString *)getCacheSize:(NSString *)path{
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    float temp = [cache getSize];
    NSString * _imageViewCacheSize = @"";
    if (temp >= 1024) {
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fM",temp/1024/1024];
    }else{
        
        _imageViewCacheSize = [NSString stringWithFormat:@"%.2fKB",temp/1024];
    }
    
    return _imageViewCacheSize;
}

+ (void)cleanCaches:(void(^)(void))completeBlock{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        completeBlock();
    }];
}

#pragma mark -版本更新
+ (void)checkVersionForAppStore{
    //   获取当前版本号
    [App_ZLZ_Helper showLoadingView:@"请求中..."];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *cuttentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = response;
    [manager GET:[NSString stringWithFormat:@"%@interUtils/findVersion.html",@""] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@成功返回:%@",task.currentRequest,responseObject);
        [App_ZLZ_Helper removeLoadingView];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSString * version = responseObject[@"data"][@"iosVersion"];
            if (![cuttentVersion isEqualToString:version]) {
                // 版本号不同
                [App_ZLZ_Helper addAlertToGetLatestVersionWithType:@"2"];
            }else{
                [CommonAlertView showAlertWithMessage:@"暂无更新" AndTitle:@"温馨提示" Action:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [App_ZLZ_Helper removeLoadingView];
    }];
}
+ (void)addAlertToGetLatestVersionWithType:(NSString *)type{
    
    if ([[NSString stringWithFormat:@"%@",type] isEqualToString:@"2"]) {
        
        [ChooseAlertView showChooseViewWithTitle:@"提示" ContentText:@"AppStore有新版本是否需要更新" AndSureAction:^{
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1074703593"]]) {
                // 能打开appStroe的情况
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1074703593"]];
            }else{
                [CommonAlertView showAlertWithMessage:@"目前找不到AppStore,请下载Appstore更新项目" AndTitle:@"提示" Action:nil];
            }
        }];
        
        
    }
    
}
+ (void)showErrorMessageAlertAutoGone:(NSString *)message {
    [MBProgressHUD showError:message toView:[UIApplication sharedApplication].keyWindow];
}
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}
@end
