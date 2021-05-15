//
//  GSPedometerManager.m
//  GSPedometer
//
//  Created by GSNICE on 2021/5/15.
//

#import "GSPedometerManager.h"
#import <CoreMotion/CoreMotion.h>

/*
 CMPedometer 简介
    
 CMPedometer 是 iOS8 以后推出的，CoreMotion 框架中获取用户运动信息的对象，通过 CMPedometer 我们可以获取用户的活动信息，如行走步数，行走的公里数，上下楼层数以及平均速度等。
 因此，我们可以通过 CMPedometer 调用它的 API 接口，就完全可以获取到我们想要的步数。
 */

/*
 📢 注意：
    1. CMPedometer 只支持在 iOS 8 及以后使用（iPhone 5S 及以上机型），iOS 8 之前可以用 CMSetpCounter。
    2. 要使用 CMPedometer，需要导入 CoreMotion 并声明属性，并在 viewDidiLoad: 中创建实例。
        #import <CoreMotion/CoreMotion.h>
        @property (nonatomic, strong) CMPedometer * pedonmeter;
    3. Error Domain=CMErrorDomain Code=105  该错误是因为没有设置 info.plist 文件中的 Motion 隐私选项(Privacy - Motion Usage Description)或者是未在设置->隐私->运动与健康 中打开权限。
    4. 另一个错误 Error Domain=CMErrorDomain Code=104（或者103？）是因为 pedometer 不是 property 属性（全局属性） 。
 */

@interface GSPedometerManager ()

@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation GSPedometerManager

+ (GSPedometerManager *)sharedInstance {
  static dispatch_once_t pred;
    
  static GSPedometerManager *sharedInstance = nil;

  dispatch_once(&pred, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
      if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [[CMPedometer alloc] init];
      }
  }
  return self;
}

/**
 *  查询某时间段的运动数据
 *
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param handler 查询结果
 */
- (void)queryPedometerDataFromDate:(NSDate *)start
                            toDate:(NSDate *)end
                       withHandler:(GSPedometerDataHandler)handler {
    
    //  在给定时间范围内查询用户的行走活动，数据最多可以使用 7 天内有效，返回的数据是从系统范围的历史记录中计算出来的，该历史记录是在后台连续收集的。结果返回在串行队列中。
    [_pedometer queryPedometerDataFromDate:start
                                    toDate:end
                               withHandler:^(CMPedometerData *_Nullable pedometerData, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
                             
            GSPedometerData *customPedometerData = [[GSPedometerData alloc] init];
                             
            customPedometerData.startDate = pedometerData.startDate;
            customPedometerData.endDate = pedometerData.endDate;
            customPedometerData.numberOfSteps = pedometerData.numberOfSteps;
            customPedometerData.distance = pedometerData.distance;
            customPedometerData.floorsAscended = pedometerData.floorsAscended;
            customPedometerData.floorsDescended = pedometerData.floorsDescended;
            customPedometerData.currentPace = pedometerData.currentPace;
            customPedometerData.currentCadence = pedometerData.currentCadence;
            customPedometerData.averageActivePace = pedometerData.averageActivePace;
              
            handler(customPedometerData, error);
        });
    }];
}

/**
 *  监听今天（从零点开始）的行走数据
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerUpdatesTodayWithHandler:(GSPedometerDataHandler)handler {
    NSDate *toDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
    
    //  在串行队列上启动一系列连续计步器更新到处理程序。 对于每次更新，应用程序将从指定的开始日期和与最新确定相关联的时间戳开始收到累积的行人活动。 如果应用程序在后台进行背景调整，则应用程序将在下次更新中收到在后台期间累积的所有行人活动。
    [_pedometer startPedometerUpdatesFromDate:fromDate
                                  withHandler:^(CMPedometerData *_Nullable pedometerData, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
                                
            GSPedometerData *customPedometerData = [[GSPedometerData alloc] init];
            
            customPedometerData.startDate = pedometerData.startDate;
            customPedometerData.endDate = pedometerData.endDate;
            customPedometerData.numberOfSteps = pedometerData.numberOfSteps;
            customPedometerData.distance = pedometerData.distance;
            customPedometerData.floorsAscended = pedometerData.floorsAscended;
            customPedometerData.floorsDescended = pedometerData.floorsDescended;
            customPedometerData.currentPace = pedometerData.currentPace;
            customPedometerData.currentCadence = pedometerData.currentCadence;
            customPedometerData.averageActivePace = pedometerData.averageActivePace;
            
            handler(customPedometerData, error);
        });
    }];
}

/**
 *  在串行队列上启动计步器事件更新（事件仅在应用程序在前台/后台运行时可用）【iOS 10.0 引入】
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerEventUpdatesWithHandler:(GSPedometerEventHandler)handler {
    [_pedometer startPedometerEventUpdatesWithHandler:^(CMPedometerEvent * _Nullable pedometerEvent, NSError * _Nullable error) {
        
        GSPedometerEvent *customPedometerEvent = [[GSPedometerEvent alloc] init];
        
        customPedometerEvent.date = pedometerEvent.date;
        customPedometerEvent.type = pedometerEvent.type;
        
        handler(customPedometerEvent, error);
    }];
}

/**
 *  停止计步器事件更新【iOS 10.0 引入】
 */
- (void)stopPedometerEventUpdates {
    if (@available(iOS 10.0, *)) {
        [_pedometer stopPedometerEventUpdates];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 权限判断
/**
 *  停止监听运动数据
 */
- (void)stopPedometerUpdates {
    [_pedometer stopPedometerUpdates];
}

/**
 *  判断设备是否支持步长计数功能
 *
 *  @return YES or NO
 */
+ (BOOL)isStepCountingAvailable {
    return [CMPedometer isStepCountingAvailable];
}

/**
 *  除步长计数外，设备是否支持距离估计
 *
 *  @return YES or NO
 */
+ (BOOL)isDistanceAvailable {
    return [CMPedometer isDistanceAvailable];
}

/**
 *  除步长计数外，设备是否支持楼梯高度计数
 *
 *  @return YES or NO
 */
+ (BOOL)isFloorCountingAvailable {
    return [CMPedometer isFloorCountingAvailable];
}

/**
 *  除步长计数外，设备是否支持速度估计
 *
 *  @return YES or NO
 */
+ (BOOL)isPaceAvailable {
    return [CMPedometer isPaceAvailable];
}

/**
 *  除步长计数外，设备是否支持节奏估计
 *
 *  @return YES or NO
 */
+ (BOOL)isCadenceAvailable {
    return [CMPedometer isCadenceAvailable];
}

/**
 *  设备是否支持计步器事件
 *
 *  @return YES or NO
 */
+ (BOOL)isPedometerEventTrackingAvailable {
    if (@available(iOS 10.0, *)) {
        return [CMPedometer isPedometerEventTrackingAvailable];
    } else {
        // Fallback on earlier versions
        return NO;
    }
}

/**
 *  返回计步器的当前授权状态【iOS 11.0 引入】
 *
 *  @return
 *  CMAuthorizationStatusNotDetermined = 0,
 *  CMAuthorizationStatusRestricted,
 *  CMAuthorizationStatusDenied,
 *  CMAuthorizationStatusAuthorized
 */
+ (CMAuthorizationStatus)authorizationStatus {
    if (@available(iOS 11.0, *)) {
        return [CMPedometer authorizationStatus];
    } else {
        // Fallback on earlier versions
        return CMAuthorizationStatusNotDetermined;
    }
}

@end
