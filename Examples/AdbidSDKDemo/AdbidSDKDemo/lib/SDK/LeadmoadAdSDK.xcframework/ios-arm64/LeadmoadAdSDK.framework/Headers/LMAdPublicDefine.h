//
//  LMAdPublicDefine.h
//  LeadMoadAdSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#ifndef LMAdPublicDefine_h
#define LMAdPublicDefine_h

typedef NS_ENUM(NSInteger, LMAdLogLevel) {
    LMAdLogLevelNone = 0,   // 关闭所有日志
    LMAdLogLevelError,      // 仅错误日志（必须关注）
    LMAdLogLevelWarning,    // 警告日志（潜在问题）
    LMAdLogLevelInfo,       // 普通信息（流程节点）
    LMAdLogLevelDebug       // 调试日志（详细过程，仅Debug模式）
};

// SDK内部日志级别（不对外暴露）
typedef NS_ENUM(NSInteger, LMAdInternalLogLevel) {
    LMAdInternalLogLevelInternal = 100  // SDK内部调试日志（仅SDK开发时使用）
};

typedef NS_ENUM(NSInteger, LMSplashLandingPageType) {
    LMSplashLandingPageType_Unknow          = 0, // 未知 
    LMSplashLandingPageType_lp    = 1, // 落地页（html/h5）
    LMSplashLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LMSplashLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LMSplashLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LMSplashLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LMSplashLandingPageType_AppStore        = 6, // ios应用商店下载
};

typedef NS_ENUM(NSInteger, LMAdPlatform) {
    LMAdPlatform_Unknown = 0,
    LMAdPlatform_GDT = 1,
    LMAdPlatform_CSJ = 2,
    LMAdPlatform_Kuaishou = 3,
    LMAdPlatform_Baidu = 4,
    LMAdPlatform_AdMob = 5,
    LMAdPlatform_Pangle = 6,
    LMAdPlatform_AppLovin = 7,
    LMAdPlatform_Unity = 8,
    LMAdPlatform_IronSource = 9,
    LMAdPlatform_Mintegral = 10,
    LMAdPlatform_Vungle = 11,
    LMAdPlatform_Chartboost = 12,
};

typedef NS_ENUM(NSInteger, LeadmoadAdType) {
    LeadmoadAdType_Splash              = 1, // 开屏
    LeadmoadAdType_Banner              = 2, // 横幅
    LeadmoadAdType_Interstitial        = 3, // 插屏
    LeadmoadAdType_Feed                = 4, // 信息流
    LeadmoadAdType_RewardVideo         = 5, // 激励视频
    LeadmoadAdType_Draw                = 6,  // draw
    LeadmoadAdType_Unknow              = 7, // 未知
};

static inline NSString *LeadmoadAdTypeString(LeadmoadAdType type) {
    switch (type) {
        case LeadmoadAdType_Splash: return @"splash";
        case LeadmoadAdType_Banner: return @"banner";
        case LeadmoadAdType_Interstitial: return @"interstitial";
        case LeadmoadAdType_Feed: return @"feed";
        case LeadmoadAdType_RewardVideo: return @"reward";
        case LeadmoadAdType_Draw: return @"draw";
        default: return @"unknown";
    }
}

/// 交互类型 21  摇一摇 (支持开屏、插屏、激励)
/// 22  扭一扭 (支持开屏、插屏、激励 部分设备不支持扭一扭)
/// 23  划一划 (支持开屏、插屏、激励)
/// 24  仅按钮可触发点击(支持开屏、插屏、激励视频)

typedef NS_ENUM(NSInteger, LeadmoadInteractionType) {
    LeadmoadInteractionType_AllClick       = 1, // 全屏点击
    LeadmoadInteractionType_AreaClick      = 24, // 区域点击
    LeadmoadInteractionType_Shake          = 21, // 摇一摇
    LeadmoadInteractionType_Slide          = 23, // 滑动
    LeadmoadInteractionType_SlideClick     = 5, // 划一划且点击
    LeadmoadInteractionType_Twist          = 22, // 扭一扭
    LeadmoadInteractionType_None           = 999
};

typedef NS_ENUM(NSInteger, LeadmoadEventType) {
    LeadmoadEventType_Impression           = 1, // 曝光
    LeadmoadEventType_Click                = 2, // 点击
};

typedef NS_ENUM(NSInteger, LeadmoadBidResult) {
    LeadmoadBidResult_Win                  = 1, // 竞胜
    LeadmoadBidResult_Loss                 = 2, // 竞败
    LeadmoadBidResult_Unknown              = 0, // 未知
};

// MARK: - Error

static NSString *const LMAdSDKErrorDomain = @"com.leadmoad.ad.sdk.error";

typedef NS_ENUM(NSInteger, LMAdErrorCode) {
    LMAdErrorCodeInitFailed = 1100,
    LMAdErrorCodeParamMissing = 1010, // 参数缺失（通用参数缺失场景）
    LMAdErrorCodeAdTimeout = 1011, // 广告超时
    LMAdErrorCodeNoAd = 1012, // 无广告
    LMAdLoadErrorCode_ImageNoCache = 1013, // 无图片缓存
    LMAdLoadErrorCode_ImageUrlIsNil = 1014, // 图片URL为空
    LMAdLoadErrorCode_ImageSaveToLocalError = 1016, // 图片保存到本地失败
    LMAdLoadErrorCode_ImageDataWrong = 1017, // 图片数据错误
    LMAdLoadErrorCode_ImageLoadError = 1018, // 图片加载失败
    LMAdLoadErrorCode_VideoUrlIsNil = 1015, // 视频URL为空
    LMAdLoadErrorCode_VideoUrlError = 1019, // 视频URL错误
    LMAdErrorCode_VideoPlayError = 1020, // 视频播放错误
    LMAdErrorCodeAdNotReady = 1021, // 广告未准备好
    LMAdErrorCodeAdShowing = 1022, // 广告正在展示中
};

// 错误描述细化，明确指出是广告ID缺失
static inline NSString *LMAdErrorDescription(LMAdErrorCode code) {
    switch (code) {
        // ... 其他描述
        case LMAdErrorCodeInitFailed:
            return @"SDK 初始化失败";
        case LMAdErrorCodeParamMissing: 
            return @"缺少必要参数";
        case LMAdErrorCodeAdTimeout:
            return @"广告请求超时";
        case LMAdErrorCodeNoAd:
            return @"无广告";
        case LMAdLoadErrorCode_ImageNoCache:
            return @"无图片缓存";
        case LMAdLoadErrorCode_ImageUrlIsNil:
            return @"图片URL为空";
        case LMAdLoadErrorCode_ImageSaveToLocalError:
            return @"图片保存到本地失败";
        case LMAdLoadErrorCode_VideoUrlIsNil:
            return @"视频URL为空";
        case LMAdLoadErrorCode_VideoUrlError:
            return @"视频URL错误";
        case LMAdErrorCode_VideoPlayError:
            return @"视频播放错误";
        case LMAdErrorCodeAdNotReady:
            return @"广告未准备好";
        default: return @"未知错误";
    }
}

#endif /* LMAdPublicDefine_h */
