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
    [formatter setDateFormat:@"HH:mm:ss yyyy-mm-dd"];
    timeLabel.text = [formatter stringFromDate:[_laserAlarm alarmTimeUtc]];
    alarmTypeLabel.text = [GlobalSettings alarmTypeAsString:[_laserAlarm alarmType]];
    sensorLabel.text = [_sensor sensorDescription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark My Event handlers
//
// Go back to the previous screen.
//
- (IBAction)back:(id)sender
{
    [self.delegate laserAlarmViewControllerDidCancel:self];
}

@end
