//
//  App_ZLZ_Helper.h
//  融通天下
//
//  Created by MyApple on 13/03/2018.
//  Copyright © 2018 坤亚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define ZLZStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ZLZStatusBarHeight_swift (UIApplication.shared.statusBarFrame.size.height)
#define ZLZNavBarHeight (self.navigationController.navigationBar.frame.size.height)
#define ZLZTabBarHeight  (self.tabBar.frame.size.height)
//按比例获取宽度   根据375的屏幕
#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0
#define  C_HEIGHT(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/667.0
#define VERIFY_CODE_INTERVAL 60
//枚举
typedef enum {
    USER_TYPE_NORMAL=1,
    USER_TYPE_VOLUNTEER_CAR,
    USER_TYPE_BUSINESS,
    USER_TYPE_ORGANISE_MANAGEMENT,//consultant
    USER_TYPE_CONSULTANT,
    USER_TYPE_ORGANISE_NORMAL,
    USER_TYPE_VOLUNTEER_LOVE
} USER_TYPE;

@interface App_ZLZ_Helper : NSObject

@property (nonatomic, weak) UIViewController * realNameComeViewController;
@property (nonatomic, assign) double current_latitude;
@property (nonatomic, assign) double current_longitude;
@property (nonatomic, retain) NSString * current_city;
@property (nonatomic, copy) NSArray * carsARR; //缓存汽车品牌
@property (nonatomic, copy) NSArray * carsInexARR;
typedef enum {
    RequestType_Get=0,
    RequestType_Post
} RequestType;

+ (App_ZLZ_Helper*)getHelper;

- (UIView *)addJinDuView:(NSArray *)dataArr index:(int)i useController:(UIViewController*)vc;
- (NSString *)getServiceStr;
- (NSString *)getRootImageUrlStr;
- (NSString *)getXIAOZHUDAI_Macro;
- (NSDictionary *)getUSERINFO;
+ (NSDictionary *)getUSERINFO;
+ (NSString *)getUserID;
- (NSString *)getFACE_LICENSE_NAME;
- (NSString *)getFACE_LICENSE_SUFFIX;
- (NSString *)getFACE_LICENSE_ID;

+ (int)getVERIFY_CODE_INTERVAL;

//根据省份证号获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr;
/**
 根据生日计算年龄
 */
+ (NSInteger)ageWithDateOfBirth:(NSString *)dateStr;
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;
+(NSString *)getStringFromObj:(NSObject*)obj;
+(BOOL)isBankCard:(NSString *)cardNo;
+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+(UIColor *)colorWithHexString:(NSString *)color;
+(BOOL)isIphoneX;
+(float)screenWidth;
+(float)screenHeight;
+(BOOL)validePhoneNumber:(NSString *)phoneNumber;
+(BOOL)valideCarNumber:(NSString *)carNumber;
+(UIColor *)getMainStyleColor;
+(UIColor *)getBaseControllerBackColor;
+(UIColor *)getCONTROLLERCOLOR;
//支付宝付款
//获取订单信息并支付
+ (void)getOrderStrFromServerAndPayUseGoodsName:(NSString *)goodsName andGoodsPrice:(NSString*)goodsPrice andType:(NSString*)type andOrderId:(NSString *)orderId andPaySucessOrFailed:(void(^)(int))sucessOrFailedBlock;
+ (void)payUseAliPay:(NSString *)signOrderString andResultCallBack:(void(^)(int))callback;

//网络请求
+ (void)sendDataToServerUseUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock;
+ (void)sendDataToServerUseUniqueUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock;
+ (void)sendDataToServerUseUrlTextHtmlContentType:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock;
+ (void)sendImagesAndDataToServerUseUrl:(NSString *)url dataDict:(NSDictionary *)dict type:(RequestType)type loadingTitle:(NSString *)loadingTitle sucessTitle:(NSString *)sucessTitle sucessBlock:(void(^)(NSDictionary*))successBlock failedBlock:(void(^)(NSError *))failedBlock andImageArr:(NSArray *)imagesArr andFileName:(NSString *)fileNameKey;

+ (BOOL)valideUserInfoIsComplete:(UIViewController *)controller;

+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation;

+ (BOOL)valideRealName:(UIViewController *)controller andCancelBlock:(void(^)())cancelBlock andIsNeedPop:(BOOL)isPop;
+ (BOOL)valideRealName;
+ (void)showValideRealNameView:(void(^)())sureBlock;
//UILabel加载HTML文本  并返回高度
+ (CGFloat)labelLoadHtml:(NSString *)htmlStr andLabel:(UILabel*)label;
+ (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent;

//截图
+ (UIImage *)getImageFromScrollView:(UIScrollView*)scrollV;
+ (UIImage *)getImageFromUIView:(UIView *)view;

//显示删除loading
+ (void)showLoadingView:(NSString *)title;
+ (void)removeLoadingView;
    
+ (int)getUserType;

+ (BOOL)judgeUserType:(USER_TYPE)type;
    
//判断有无车辆信息
+ (void)isHaveCars:(void(^)(BOOL isHave))completeBlock;
//传入秒获取时分秒   传入秒获取分秒
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;
+(NSString *)getMMSSFromSS:(NSString *)totalTime;

//向某人打电话
+ (void)callPerson:(NSString *)phoneNumber andController:(UIViewController*)vc;
//显示汽车输入牌号
+ (void)showVehicalNumber:(UIViewController *)vc;
//JSON转NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//过滤空值
+ (NSString *)getSafeString:(NSString *)str;
//获取注册天数
+ (NSInteger)getRegisterDays:(NSString *)dateStr;
+ (void)showErrorMessageAlert:(NSString *)message;
//时间转换为几分钟前，几小时前等
+ (NSString *)updateTimeForRow:(NSString *)dateStr;

//计算文字高度
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
+ (CGFloat)labelSingleRowWidth:(NSString*)text fontSize:(CGFloat)fontSize;

//计算缓存大小  如果不传就计算
+ (NSString *)getCacheSize:(NSString *)path;
//清除缓存
+ (void)cleanCaches:(void(^)(void))completeBlock;
+ (void)showErrorMessageAlertAutoGone:(NSString *)message;

#pragma mark -版本更新
+ (void)checkVersionForAppStore;
+ (AppDelegate *)getAppDelegate;
@end
