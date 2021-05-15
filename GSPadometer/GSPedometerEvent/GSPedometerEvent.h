//
//  GSPedometerEvent.h
//  GSPedometer
//
//  Created by GSNICE on 2021/5/15.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSPedometerEvent : NSObject

/// 事件发生的时间
@property(nonatomic, strong, nullable)NSDate *date;

/// 描述行走活动过渡的事件类型
@property(nonatomic, assign) CMPedometerEventType type;

@end

NS_ASSUME_NONNULL_END
