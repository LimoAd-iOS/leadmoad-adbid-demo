//
//  FLinkBaseAdManager.h
//  FLinkAdSaas
//
//  Created by lurich on 2022/11/8.
//

#import <Foundation/Foundation.h>
#import <FLinkAdSaas/FLinkVideoConfig.h>
#import "FLinkMediaInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FLinkADResultTypeStart,
    FLinkADResultTypeRequestAD,
    FLinkADResultTypeLoadAD,
    FLinkADResultTypeFail,
    FLinkADResultTypeShow,
    FLinkADResultTypeClick,
    FLinkADResultTypeClose,
    FLinkADResultTypeShowFail
} FLinkADResultType;

@interface FLinkADInfo : NSObject

/// 广告主名称
@property (nonatomic, copy) NSString *adnName;

/// 广告主APPID
@property (nonatomic, copy) NSString *adnAppID;

/// 广告位ID
@property (nonatomic, copy) NSString *adnPlaceID;

/// 最佳ECPM
@property (nonatomic) double ecpm;

/// 当前平台的APPID
@property (nonatomic, copy) NSString *appID;

/// 当前平台的广告位ID
@property (nonatomic, copy) NSString *placeID;

/// 广告加载ID
@property (nonatomic, copy) NSString *requestID;

/// 1、开屏、2、 插屏、3、 信息流（31：自渲染；32：模板）、4、 激励视频、5、 横幅
@property (nonatomic, assign) NSInteger adType;

/**
 * 返回广告是否可展示
 * @return 当广告已经加载完成&&未曝光&&未过期时，为YES，否则为NO
 */
@property (nonatomic, assign) BOOL isAdValid;

/// 初始化时传入的自定义信息
@property (nonatomic, strong) NSMutableDictionary *userInfo;

/// 媒体素材信息
@property (nonatomic, strong, nullable) FLinkMediaInfo *mediaInfo;

@end

@interface FLinkBaseAdManager : NSObject

/// 获取广告的广告位ID，必传
@property (nonatomic, copy) NSString *mediaId;

/// 视频相关控制，可选
@property (nonatomic, strong) FLinkVideoConfig *videoConfig;

/// 自定义请求广告超时时间，可选，单位秒，建议至少 3 秒以上，（PS：设置请求限时，可能影响广告收益，非必要不要设置）
@property (nonatomic) double timeout;

/// 使用广告位ID初始化。
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 是否可以请求广告数据
- (BOOL)isCanLoadAD;

/// 加载广告数据
- (void)loadAdData;

/// 填充后可调用，返回当前最佳广告的信息
- (FLinkADInfo *)getCurrentBaseEcpmInfo;

/// 用户传入的自定义信息
-(NSMutableDictionary *) getUserInfoDic;

/// 自定义请求广告超时可调用，调用后可立即获得当前请求结果（成功 or 失败）
- (void)getCurrentBaseEcpmAD;

/// 获取广告ID列表
- (NSArray *) getADIDList;


/// ** 媒体竞价展示广告时需要上报，需要在调用广告 show 之前调用 **
/**
 *  ======= 我方竞胜后需要回传第二价 =======
 * @param secondPrice 媒体二价  (单位: 分)
 */
- (void)sendWinNotificationWithPrice:(CGFloat)secondPrice;
/**
 * ======= 我方竞败后需要回传最高价以及竞败原因 =======
 * @param firstPrice 媒体一价  (单位: 分)
 */
- (void)sendLossNotificationWithPrice:(CGFloat)firstPrice;

@end

@interface FLinkADResultInfo : NSObject

/// 广告信息
@property (nonatomic, strong) FLinkADInfo *info;

/// 广告填充失败时的错误信息
@property (nonatomic, copy, nullable) NSError *error;;

/// 开屏广告流程状态
@property (nonatomic, assign) FLinkADResultType type;

@end

NS_ASSUME_NONNULL_END
