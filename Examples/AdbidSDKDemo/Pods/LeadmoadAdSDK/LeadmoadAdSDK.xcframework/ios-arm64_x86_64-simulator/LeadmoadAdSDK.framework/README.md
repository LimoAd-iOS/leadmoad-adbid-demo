# Native 信息流自渲染广告模块分析

## 一、核心类总览

### 1. `LMNativeAd` — 广告管理核心（主入口）

**文件：** `LMNativeAd.h / LMNativeAd.m`（494 行）

| 类型 | 名称 | 作用 |
|------|------|------|
| 属性 | `data: LMNativeObj` | 广告素材数据（只读） |
| 属性 | `delegate` | 代理，接收加载/曝光/点击回调 |
| 属性 | `rootViewController` | 广告跳转时的根视图控制器 |
| 属性 | `maxLoadTime` | 最大加载时长（毫秒，默认 5000） |
| 属性 | `eCPM` | 广告出价（用于竞价排序） |
| 属性 | `valid` | 广告是否可展示 |
| 方法 | `initWithSlotId:` | 初始化广告位 |
| 方法 | `loadAd` | 发起广告加载请求 |
| 方法 | `registerContainer:withClickableViews:` | 注册容器视图和可点击区域，触发曝光检测 |
| 方法 | `winNotice:` | 竞胜通知（Bidding 场景） |
| 方法 | `lossNotice:` | 竞败通知（Bidding 场景） |
| 方法 | `isReady` | 检查广告是否已准备好展示 |

---

### 2. `LMNativeAdDelegate` — 广告事件回调协议

```
必需：
  - nativeAdDidLoad:                      // 广告加载成功
  - nativeAd:didFailToLoadWithError:      // 广告加载失败

可选：
  - nativeAdViewDidExpose:                // 广告曝光
  - nativeAdViewDidClick:withView:        // 广告被点击
```

---

### 3. `LMNativeObj` — 广告素材数据模型

**文件：** `LMNativeObj.h / LMNativeObj.m`

承载服务端返回的广告素材内容，供开发者自行渲染 UI：

| 属性 | 说明 |
|------|------|
| `title` | 广告标题 |
| `desc` | 广告描述文案 |
| `imageUrl` | 大图 URL（主图） |
| `iconUrl` | Logo/Icon URL |
| `videoUrl` | 视频 URL（视频广告时有值） |
| `imageObjc: LMImageObj` | 图片对象（含宽高） |
| `style` | 广告样式 ID（见下表） |
| `isVideoAd` | 是否为视频广告 |

**广告样式枚举：**

| style 值 | 说明 |
|----------|------|
| 40201 | 640×100 横幅 |
| 40202 | 16:9 横版图文 |
| 40501 | 9:16 竖版图片 |
| 40502 | 16:9 横版图片 |
| 40503 | 9:16 竖版视频 |
| 40504 | 16:9 横版视频 |

---

### 4. `LMNativeView` — 自渲染 UI 容器视图

**文件：** `LMNativeView.h / LMNativeView.m`（35 行）

继承 `UIView`，用于视频广告的自渲染容器，自动管理内部 `LMNativeMediaView`：

| 类型 | 名称 | 作用 |
|------|------|------|
| 属性 | `mediaView: LMNativeMediaView` | 视频播放视图（只读，动态创建） |
| 方法 | `refreshData:(LMNativeAd *)` | 绑定广告数据，触发视频播放 |

---

### 5. `LMNativeMediaView` — 视频媒体播放视图

**文件：** `LMNativeMediaView.h / LMNativeMediaView.m`（137 行）

| 属性/方法 | 作用 |
|-----------|------|
| `contentURL` | 视频内容 URL |
| `muted` | 静音控制 |
| `videoCycleOnce` | 仅播放一次 |
| `play` / `pause` / `stop` | 播放控制 |
| `appDidEnterBackground` | 进后台自动暂停 |
| `appWillEnterForeground` | 返回前台自动恢复 |

**`LMNativeMediaViewDelegate`：**

```
- nativeMediaViewDidClick:              // 视频点击
- nativeMediaViewReadyToPlay:           // 准备就绪
- nativeMediaViewDidPlayFinished:       // 播放完成
- nativeMediaView:didPlayFailWithError: // 播放失败
```

---

## 二、支撑层核心类

| 类 | 职责 |
|----|------|
| `LMAdProvider` | 广告网络请求、点击处理、追踪 URL 执行 |
| `LMADXResponseModel` | 服务端响应数据模型（含追踪 URL、视频/图片信息） |
| `LMAdCachePoolManager` | 广告缓存池管理（按类型+slotId，最多 5 条，有效期 2h） |
| `LMCacheManager` | 统一媒体缓存（图片/视频本地缓存） |
| `LMAssetPreparer` | 广告资源预加载（图片/视频下载） |
| `LMMediaDownloader` | 实际媒体下载执行（支持进度回调） |
| `LMCommonVideoView` | AVPlayer 封装，提供播放/暂停/结束回调 |
| `LMAdLogReporter` | 广告行为上报（加载/曝光/点击/竞胜/竞败） |

---

## 三、完整工作流程

```
【加载阶段】
LMNativeAd.loadAd
  → LMAdProvider 发起网络请求
  → LMAdCachePoolManager 检查/存缓存
  → LMNativeObj.convertModel: 解析素材
  → LMAssetPreparer 预加载图片/视频
  → delegate.nativeAdDidLoad: 回调通知

【展示阶段】
LMNativeAd.registerContainer:withClickableViews:
  → 视图可见性检测（superview/hidden/alpha/frame）
  → LMAdLogReporter 上报曝光
  → LMAdCachePoolManager.confirmDisplayed
  → delegate.nativeAdViewDidExpose: 回调

【视频播放】
LMNativeView.refreshData:
  → LMNativeMediaView 设置 contentURL
  → LMCacheManager 检查本地缓存
  → LMCommonVideoView (AVPlayer) 开始播放
  → LMNativeMediaViewDelegate 播放状态回调

【点击阶段】
手势触发 → LMAdLogReporter 上报点击
  → LMAdProvider.callbackForUrls: 执行追踪
  → LMAdProvider.handleClickWithMacroInfo: 处理跳转（H5/DeepLink/AppStore）
  → delegate.nativeAdViewDidClick: 回调
```

---

## 四、类继承与依赖关系图

```
UIView
├── LMNativeView            ← 自渲染容器（开发者使用）
│   └── 内含 LMNativeMediaView
└── LMNativeMediaView       ← 视频播放
    └── 内含 LMCommonVideoView (AVPlayer封装)

NSObject
├── LMNativeAd              ← 广告管理主类
│   ├── 持有 LMNativeObj    ← 素材数据
│   ├── 持有 LMAdProvider   ← 网络/追踪
│   └── 持有 LMADXResponseModel ← 原始响应
│
└── LMADXResponseModel
    ├── LeadmoadVideoModel  ← 视频信息+追踪点
    ├── LeadmoadImgModel    ← 图片信息
    ├── LeadmoadDownloadModel ← 应用下载
    └── LeadmoadDeepModel   ← 深度链接
```

---

## 五、协议/代理关系

```
LMNativeAdDelegate（LMNativeAd 的代理）
├── 必需：-nativeAdDidLoad:
├── 必需：-nativeAd:didFailToLoadWithError:
├── 可选：-nativeAdViewDidExpose:
└── 可选：-nativeAdViewDidClick:withView:

LMNativeMediaViewDelegate（LMNativeMediaView 的代理）
├── 可选：-nativeMediaViewDidClick:
├── 可选：-nativeMediaViewReadyToPlay:
├── 可选：-nativeMediaViewDidPlayFinished:
└── 可选：-nativeMediaView:didPlayFailWithError:
```

---

## 六、数据模型详情

### `LMADXResponseModel`（服务端响应模型）

| 属性 | 类型 | 说明 |
|------|------|------|
| `title` | `NSString` | 广告标题 |
| `desc` | `NSString` | 广告描述 |
| `price` | `NSInteger` | eCPM 出价（分/CPM） |
| `target_url` | `NSString` | 落地页 URL |
| `imp_trackers` | `NSArray<NSString *>` | 曝光上报 URL 列表 |
| `click_trackers` | `NSArray<NSString *>` | 点击上报 URL 列表 |
| `win_notice` | `NSArray<NSString *>` | 竞胜上报 URL 列表 |
| `loss_notice` | `NSArray<NSString *>` | 竞败上报 URL 列表 |
| `imgs` | `NSArray<LeadmoadImgModel *>` | 图片列表 |
| `icon` | `NSString` | Logo URL |
| `video` | `LeadmoadVideoModel` | 视频信息 |
| `download` | `LeadmoadDownloadModel` | 下载信息 |
| `deep` | `LeadmoadDeepModel` | 深度链接信息 |
| `cache_time` | `NSInteger` | 缓存有效期（秒） |

### `LeadmoadVideoModel`（视频数据模型）

| 属性 | 说明 |
|------|------|
| `video_url` | 视频地址 |
| `cover_url` | 封面 URL |
| `duration` | 播放时长（秒） |
| `video_width / video_height` | 视频尺寸 |
| `video_start` | 播放开始追踪 URL |
| `play_quarter` | 播放 1/4 追踪 URL |
| `play_two_quarters` | 播放 2/4 追踪 URL |
| `play_three_quarters` | 播放 3/4 追踪 URL |
| `video_complete` | 播放完成追踪 URL |

---

## 七、错误码定义

| 错误码 | 含义 |
|--------|------|
| 1010 | 参数缺失 |
| 1011 | 广告请求超时 |
| 1012 | 无可用广告 |
| 1013 | 图片无本地缓存 |
| 1014 | 图片 URL 为空 |
| 1015 | 视频 URL 为空 |
| 1016 | 图片保存失败 |
| 1019 | 视频 URL 错误 |
| 1020 | 视频播放失败 |
| 1021 | 广告未准备好展示 |

---

## 八、开发者接入示例（自渲染）

```objc
// 1. 创建广告对象
LMNativeAd *ad = [[LMNativeAd alloc] initWithSlotId:@"your_slot_id"];
ad.delegate = self;
ad.rootViewController = self;

// 2. 发起加载
[ad loadAd];

// 3. 回调中取素材，自行搭建 UI
- (void)nativeAdDidLoad:(LMNativeAd *)nativeAd {
    LMNativeObj *data = nativeAd.data;
    // 使用 data.title / data.imageUrl / data.isVideoAd 构建自定义视图

    if (data.isVideoAd) {
        LMNativeView *view = [[LMNativeView alloc] initWithFrame:frame];
        [view refreshData:nativeAd];     // 触发视频播放
    }

    // 4. 注册容器视图（触发曝光监测和点击处理）
    [nativeAd registerContainer:yourView withClickableViews:@[clickBtn]];
}

// 5. 广告加载失败
- (void)nativeAd:(LMNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"加载失败: %@", error);
}

// 6. 广告曝光（可选）
- (void)nativeAdViewDidExpose:(LMNativeAd *)nativeAd {
    NSLog(@"广告已曝光");
}

// 7. 广告点击（可选）
- (void)nativeAdViewDidClick:(LMNativeAd *)nativeAd withView:(UIView *)view {
    NSLog(@"广告被点击");
}
```

---

## 九、文件清单

| 文件 | 行数 | 说明 |
|------|------|------|
| `LMNativeAd.h` | 86 | 广告管理类头文件 |
| `LMNativeAd.m` | 494 | 广告管理类实现 |
| `LMNativeObj.h` | 60 | 素材数据模型头文件 |
| `LMNativeObj.m` | 62 | 素材数据模型实现 |
| `LMNativeView.h` | 25 | 自渲染容器视图头文件 |
| `LMNativeView.m` | 35 | 自渲染容器视图实现 |
| `LMNativeMediaView.h` | 71 | 视频播放视图头文件 |
| `LMNativeMediaView.m` | 137 | 视频播放视图实现 |
