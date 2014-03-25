//
//  SystemAlarmViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 19/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "SystemAlarmViewController.h"
#import "IosMobileClientLib/SystemAlarm.h"
#import "IosMobileClientLib/Controller.h"

@interface SystemAlarmViewController ()

@end

@implementation SystemAlarmViewController

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
    timeLabel.text = [formatter stringFromDate:[_systemAlarm alarmTimeUtc]];
    alarmTypeLabel.text = [GlobalSettings alarmTypeAsString:[_systemAlarm alarmType]];
    controllerLabel.text = [_controller name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
