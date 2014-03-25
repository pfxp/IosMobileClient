//
//  LaserAlarmViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 19/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "LaserAlarmViewController.h"
#import "IosMobileClientLib/LaserAlarm.h"
#import "IosMobileClientLib/Sensor.h"

@interface LaserAlarmViewController ()

@end

@implementation LaserAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"HH:mm:ss yyyy-mm-dd"];
    [formatter setDateFormat:@"HH:mm:ss"];
    alarmTypeLabel.text = [GlobalSettings alarmTypeAsString:[_laserAlarm alarmType]];
    sensorLabel.text = [_sensor sensorDescription];
    timeLabel.text = [formatter stringFromDate:[_laserAlarm alarmTimeUtc]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
