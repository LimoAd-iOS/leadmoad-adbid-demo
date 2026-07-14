//
//  KuYingAdAdapterCommonHeader.h
//  Pods
//
//  Created by mark zhang  on 2026/1/3.
//

#ifndef KUYINGAdAdapterCommonHeader_h
#define KUYINGAdAdapterCommonHeader_h

#import <AdbidSDK/AdbidSDK.h>
#import "NSDictionary+AdbidKuYingSafe.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <LMKYAdSDK/LMKYAdSDK.h>
#import "KuYingAdbidTool.h"
/**
 数组防空判断
 */
#define isKuYingAdapterArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)

/**
 字典防空判断
 */
#define isKuYingAdapterDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)

/**
 字符串防空判断
 */
#define isKuYingAdapterStrEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) || ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0))

#endif /* LMAdCustomAdapterCommonHeader_h */
