//
//  GSPedometerData.h
//  GSPedometer
//
//  Created by GSNICE on 2021/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSPedometerData : NSObject

/// 计步器数据有效期间的开始时间（这是会话或历史查询请求的开始时间）
@property(nonatomic, strong, nullable) NSDate *startDate;

/// 计步器数据有效期间的结束时间（对于更新，这是最新更新的时间。 对于历史查询，这是请求的结束时间）
@property(nonatomic, strong, nullable) NSDate *endDate;

/// 步数
@property(nonatomic, strong, nullable) NSNumber *numberOfSteps;

/// 用户行走和跑步时估计的一米为单位的距离（若设备不支持则值为nil）
@property(nonatomic, strong, nullable) NSNumber *distance;

/// 上楼的大概楼层数（若设备不支持则值为nil）
@property(nonatomic, strong, nullable) NSNumber *floorsAscended;

/// 下楼的大概楼层数（若设备不支持则值为nil）
@property(nonatomic, strong, nullable) NSNumber *floorsDescended;

/// 对于更新，这将以s / m（每米秒）返回当前速度。 如果满足以下条件，则值为零：1. 资料尚未公布 2. 历史查询 3.平台不支持
@property(nonatomic, strong, nullable) NSNumber *currentPace;

/// 对于更新，这将返回以秒为单位执行行走的节奏。 如果满足以下条件，则值为零：1. 资料尚未公布 2. 历史查询 3.平台不支持
@property(nonatomic, strong, nullable) NSNumber *currentCadence;

/// 对于更新，这将返回自 startPedometerUpdatesFromDate：withHandler :,以s / m（每米秒））的平均活动速度。 对于历史查询，这将返回 startDate 和 endDate 之间的平均活动速度。 平均主动速度省略了非活动时间，平均步调从用户移动。 如果满足以下条件，则值为零：1. 对于历史信息查询，信息无效。例如用户在开始时间和结束时间内没有移动 2. 平台不支持
@property(nonatomic, strong, nullable) NSNumber *averageActivePace;

@end

NS_ASSUME_NONNULL_END
