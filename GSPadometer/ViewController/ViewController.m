//
//  ViewController.m
//  GSPedometer
//
//  Created by GSNICE on 2021/5/15.
//

#import "ViewController.h"
#import "GSPedometerManager.h"

@interface ViewController ()

/// 开始时间 Label
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

/// 结束时间 Label
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

/// 步数 Label
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;

/// 距离 Label
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

/// 爬楼 Label
@property (weak, nonatomic) IBOutlet UILabel *upStairsLabel;

/// 下楼 Label
@property (weak, nonatomic) IBOutlet UILabel *downstairsLabel;

/// 步伐 Label
@property (weak, nonatomic) IBOutlet UILabel *currentPaceLabel;

/// 节奏 Label
@property (weak, nonatomic) IBOutlet UILabel *currentCadenceLabel;

/// 平均步伐 Label
@property (weak, nonatomic) IBOutlet UILabel *averageActivePaceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  除步长计数外，设备是否支持距离估计
    if ([GSPedometerManager isDistanceAvailable]) {
    }
    NSLog(@"设备%@距离估计",[GSPedometerManager isPaceAvailable] ? @"支持" : @"不支持");
    
    //  除步长计数外，设备是否支持楼梯高度计数
    if ([GSPedometerManager isFloorCountingAvailable]) {
    }
    NSLog(@"设备%@楼梯高度计数",[GSPedometerManager isPaceAvailable] ? @"支持" : @"不支持");
    
    //  除步长计数外，设备是否支持速度估计
    if ([GSPedometerManager isPaceAvailable]) {
    }
    NSLog(@"设备%@速度估计",[GSPedometerManager isPaceAvailable] ? @"支持" : @"不支持");
    
    //  除步长计数外，设备是否支持节奏估计
    if ([GSPedometerManager isCadenceAvailable]) {
    }
    NSLog(@"设备%@节奏估计",[GSPedometerManager isCadenceAvailable] ? @"支持" : @"不支持");
    
    //  设备是否支持计步器事件
    if ([GSPedometerManager isPedometerEventTrackingAvailable]) {
    }
    NSLog(@"设备%@计步器事件",[GSPedometerManager isPedometerEventTrackingAvailable] ? @"支持" : @"不支持");
    
    //  返回计步器的当前授权状态
    NSLog(@"计步器的当前授权状态:%ld",(long)[GSPedometerManager authorizationStatus]);
    
    //  判断设备是否支持计步功能
    if ([GSPedometerManager isStepCountingAvailable]) {
        __weak __typeof(self)weakSelf = self;
      [[GSPedometerManager sharedInstance] startPedometerUpdatesTodayWithHandler:^(GSPedometerData *pedometerData, NSError *error) {
            if (!error) {
                NSLog(@"开始时间:%@\n",pedometerData.startDate);
                NSLog(@"结束时间:%@\n",pedometerData.endDate);
                NSLog(@"步数:%@\n",pedometerData.numberOfSteps);
                NSLog(@"距离:%@\n",pedometerData.distance);
                NSLog(@"爬楼:%@\n",pedometerData.floorsAscended);
                NSLog(@"下楼:%@\n",pedometerData.floorsDescended);
                NSLog(@"步伐:%@\n",pedometerData.currentPace == nil ? @"0" : pedometerData.currentPace);
                NSLog(@"节奏:%@\n",pedometerData.currentCadence == nil ? @"0" : pedometerData.currentCadence);
                NSLog(@"平均活动步伐:%@\n",pedometerData.averageActivePace);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSString *startDateStr = [formatter stringFromDate:pedometerData.startDate];
                NSString *endDateStr = [formatter stringFromDate:pedometerData.endDate];
                
                weakSelf.startDateLabel.text = [NSString stringWithFormat:@"%@",startDateStr];
                weakSelf.endDateLabel.text = [NSString stringWithFormat:@"%@",endDateStr];
                
                weakSelf.stepsLabel.text = [NSString stringWithFormat:@"%@ 步",pedometerData.numberOfSteps];
                weakSelf.distanceLabel.text = [NSString stringWithFormat:@"%@ 米",pedometerData.distance];
                weakSelf.upStairsLabel.text = [NSString stringWithFormat:@"%@ 层",pedometerData.floorsAscended];
                weakSelf.downstairsLabel.text = [NSString stringWithFormat:@"%@ 层",pedometerData.floorsDescended];
                weakSelf.currentPaceLabel.text = [NSString stringWithFormat:@"%@  秒 / 米",pedometerData.currentPace == nil ? @"0" : pedometerData.currentPace];
                weakSelf.currentCadenceLabel.text = [NSString stringWithFormat:@"%@ 秒",pedometerData.currentCadence == nil ? @"0" : pedometerData.currentCadence];
                weakSelf.averageActivePaceLabel.text = [NSString stringWithFormat:@"%@ 秒 / 米",pedometerData.averageActivePace];
            }
          }];
    } else {
        
      UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@"此设备不支持计步功能"
                    message:@"仅支持 iPhone5s 及其以上设备"
                   delegate:self
          cancelButtonTitle:nil
          otherButtonTitles:@"OK", nil];
      [alertView show];
    }
}


@end
