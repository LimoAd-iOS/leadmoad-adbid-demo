//
//  LMAdPublicDefine.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#ifndef LMAdPublicDefine_h
#define LMAdPublicDefine_h

typedef NS_ENUM(NSInteger, AdbidLogLevel) {
    AdbidLogLevelNone = 0,   // 关闭所有日志
    AdbidLogLevelError,      // 仅错误日志（必须关注）
    AdbidLogLevelWarning,    // 警告日志（潜在问题）
    AdbidLogLevelInfo,       // 普通信息（流程节点）
    AdbidLogLevelDebug       // 调试日志（详细过程，仅Debug模式）
};

// SDK内部日志级别（不对外暴露）
typedef NS_ENUM(NSInteger, AdbidAdInternalLogLevel) {
    AdbidAdInternalLogLevelInternal = 100  // SDK内部调试日志（仅SDK开发时使用）
};

typedef NS_ENUM(NSInteger, AdbidSplashLandingPageType) {
    AdbidSplashLandingPageType_Unknow          = 0, // 未知
    AdbidSplashLandingPageType_lp    = 1, // 落地页（html/h5）
    AdbidSplashLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    AdbidSplashLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    AdbidSplashLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    AdbidSplashLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    AdbidSplashLandingPageType_AppStore        = 6, // ios应用商店下载
};

typedef NS_ENUM(NSInteger, AdbidPlatform) {
    AdbidPlatform_Unknown = 0,
    AdbidPlatform_GDT = 1,
    AdbidPlatform_CSJ = 2,
    AdbidPlatform_Kuaishou = 3,
    AdbidPlatform_Baidu = 4,
    AdbidPlatform_AdMob = 5,
    AdbidPlatform_Pangle = 6,
    AdbidPlatform_AppLovin = 7,
    AdbidPlatform_Unity = 8,
    AdbidPlatform_IronSource = 9,
    AdbidPlatform_Mintegral = 10,
    AdbidPlatform_Vungle = 11,
    AdbidPlatform_Chartboost = 12,
};

typedef NS_ENUM(NSInteger, AdbidType) {
    AdbidType_Splash              = 1, // 开屏
    AdbidType_Banner              = 2, // 横幅
    AdbidType_Interstitial        = 3, // 插屏
    AdbidType_Feed                = 4, // 信息流
    AdbidType_RewardVideo         = 5, // 激励视频
    AdbidType_Draw                = 6,  // draw
    AdbidType_Unknow              = 7, // 未知
};

static inline NSString *AdbidTypeString(AdbidType type) {
    switch (type) {
        case AdbidType_Splash: return @"splash";
        case AdbidType_Banner: return @"banner";
        case AdbidType_Interstitial: return @"interstitial";
        case AdbidType_Feed: return @"feed";
        case AdbidType_RewardVideo: return @"reward";
        case AdbidType_Draw: return @"draw";
        default: return @"unknown";
    }
}

/// 交互类型 21  摇一摇 (支持开屏、插屏、激励)
/// 22  扭一扭 (支持开屏、插屏、激励 部分设备不支持扭一扭)
/// 23  划一划 (支持开屏、插屏、激励)
/// 24  仅按钮可触发点击(支持开屏、插屏、激励视频)

typedef NS_ENUM(NSInteger, AdbidInteractionType) {
    AdbidInteractionType_AllClick       = 1, // 全屏点击
    AdbidInteractionType_AreaClick      = 24, // 区域点击
    AdbidInteractionType_Shake          = 21, // 摇一摇
    AdbidInteractionType_Slide          = 23, // 滑动
    AdbidInteractionType_SlideClick     = 5, // 划一划且点击
    AdbidInteractionType_Twist          = 22, // 扭一扭
    AdbidInteractionType_None           = 999
};

typedef NS_ENUM(NSInteger, AdbidEventType) {
    AdbidEventType_Impression           = 1, // 曝光
    AdbidEventType_Click                = 2, // 点击
};

typedef NS_ENUM(NSInteger, AdbidBidResult) {
    AdbidBidResult_Win                  = 1, // 竞胜
    AdbidBidResult_Loss                 = 2, // 竞败
    AdbidBidResult_Unknown              = 0, // 未知
};

// MARK: - Error

static NSString *const AdbidSDKErrorDomain = @"com.Adbid.ad.sdk.error";

typedef NS_ENUM(NSInteger, AdbidErrorCode) {
    AdbidErrorCodeInitFailed = 1100,
    AdbidErrorCodeParamMissing = 1010, // 参数缺失（通用参数缺失场景）
    AdbidErrorCodeAdTimeout = 1011, // 广告超时
    AdbidErrorCodeNoAd = 1012, // 无广告
    AdbidLoadErrorCode_ImageNoCache = 1013, // 无图片缓存
    AdbidLoadErrorCode_ImageUrlIsNil = 1014, // 图片URL为空
    AdbidLoadErrorCode_ImageSaveToLocalError = 1016, // 图片保存到本地失败
    AdbidLoadErrorCode_ImageDataWrong = 1017, // 图片数据错误
    AdbidLoadErrorCode_ImageLoadError = 1018, // 图片加载失败
    AdbidLoadErrorCode_VideoUrlIsNil = 1015, // 视频URL为空
    AdbidLoadErrorCode_VideoUrlError = 1019, // 视频URL错误
    AdbidErrorCode_VideoPlayError = 1020, // 视频播放错误
    AdbidErrorCodeAdNotReady = 1021, // 广告未准备好
    AdbidErrorCodeAdShowing = 1022, // 广告正在展示中
};

// 错误描述细化，明确指出是广告ID缺失
static inline NSString *LMAdErrorDescription(AdbidErrorCode code) {
    switch (code) {
        // ... 其他描述
        case AdbidErrorCodeInitFailed:
            return @"SDK 初始化失败";
        case AdbidErrorCodeParamMissing: 
            return @"缺少必要参数";
        case AdbidErrorCodeAdTimeout:
            return @"广告请求超时";
        case AdbidErrorCodeNoAd:
            return @"无广告";
        case AdbidLoadErrorCode_ImageNoCache:
            return @"无图片缓存";
        case AdbidLoadErrorCode_ImageUrlIsNil:
            return @"图片URL为空";
        case AdbidLoadErrorCode_ImageSaveToLocalError:
            return @"图片保存到本地失败";
        case AdbidLoadErrorCode_VideoUrlIsNil:
            return @"视频URL为空";
        case AdbidLoadErrorCode_VideoUrlError:
            return @"视频URL错误";
        case AdbidErrorCode_VideoPlayError:
            return @"视频播放错误";
        case AdbidErrorCodeAdNotReady:
            return @"广告未准备好";
        default: return @"未知错误";
    }
}

#endif /* LMAdPublicDefine_h */
