//
//  TimeViewViewController.h
//  Buzzr
//
//  Created by Conor Eby on 11/23/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherFetcher.h"

@interface TimeViewViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic) BOOL alarmTriggered;
@property (nonatomic) BOOL vibrate;
@end
