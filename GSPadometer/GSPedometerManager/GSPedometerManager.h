//
//  GSPedometerManager.h
//  GSPedometer
//
//  Created by GSNICE on 2021/5/15.
//

#import <Foundation/Foundation.h>

#import "GSPedometerData.h"
#import "GSPedometerEvent.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^GSPedometerDataHandler)(GSPedometerData *pedometerData, NSError *error);

typedef void (^GSPedometerEventHandler)(GSPedometerEvent *pedometerEvent, NSError *error);

@interface GSPedometerManager : NSObject

+ (GSPedometerManager *)sharedInstance;

/**
 *  判断设备是否支持步长计数功能
 *
 *  @return YES or NO
 */
+ (BOOL)isStepCountingAvailable;

/**
 *  除步长计数外，设备是否支持距离估计
 *
 *  @return YES or NO
 */
+ (BOOL)isDistanceAvailable;

/**
 *  除步长计数外，设备是否支持楼梯高度计数
 *
 *  @return YES or NO
 */
+ (BOOL)isFloorCountingAvailable;

/**
 *  除步长计数外，设备是否支持速度估计
 *
 *  @return YES or NO
 */
+ (BOOL)isPaceAvailable;

/**
 *  除步长计数外，设备是否支持节奏估计
 *
 *  @return YES or NO
 */
+ (BOOL)isCadenceAvailable;

/**
 *  设备是否支持计步器事件
 *
 *  @return YES or NO
 */
+ (BOOL)isPedometerEventTrackingAvailable;

/**
 *  返回计步器的当前授权状态【iOS 11.0 引入】
 *
 *  @return
 *  CMAuthorizationStatusNotDetermined = 0,
 *  CMAuthorizationStatusRestricted,
 *  CMAuthorizationStatusDenied,
 *  CMAuthorizationStatusAuthorized
 */
+ (CMAuthorizationStatus)authorizationStatus;

/**
 *  查询某时间段的行走数据
 *
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param handler 查询结果
 */
- (void)queryPedometerDataFromDate:(NSDate *)start
                            toDate:(NSDate *)end
                       withHandler:(GSPedometerDataHandler)handler;

/**
 *  监听今天（从零点开始）的行走数据
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerUpdatesTodayWithHandler:(GSPedometerDataHandler)handler;

/**
 *  在串行队列上启动计步器事件更新（事件仅在应用程序在前台/后台运行时可用）【iOS 10.0 引入】
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerEventUpdatesWithHandler:(GSPedometerEventHandler)handler;

/**
 *  停止监听运动数据
 */
- (void)stopPedometerUpdates;

@end

NS_ASSUME_NONNULL_END
