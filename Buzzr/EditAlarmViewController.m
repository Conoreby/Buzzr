//
//  EditAlarmViewController.m
//  Buzzr
//
//  Created by Conor Eby on 11/25/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "EditAlarmViewController.h"
#import "Alarm+Create.h"

@interface EditAlarmViewController ()


@end

@implementation EditAlarmViewController
- (IBAction)deleteAlarm:(id)sender {
	Alarm *alarmToDelete = [Alarm createAlarmWithID:self.alarmId inManagedObjectContext:self.managedObjectContext];
	
	//Delete notification, if there is one
	NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for (UILocalNotification *notification in localNotifications){
		if (alarmToDelete.notificationID == [notification.userInfo valueForKeyPath:@"notificationID"]){
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}
	
	[self.managedObjectContext deleteObject:alarmToDelete];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDate *) getAlarmId
{
	return self.alarmId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	Alarm *alarm = [Alarm createAlarmWithID:self.alarmId inManagedObjectContext:self.managedObjectContext];
	[self.alarmTime setDate:alarm.time];
	self.labelText = alarm.label;
	self.labelTextField.text = self.labelText;
	self.vibrateEnableSwitch.on = [alarm.vibrate boolValue];
	
	MPMediaQuery *query = [MPMediaQuery songsQuery];
	[query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:alarm.song forProperty:MPMediaEntityPropertyPersistentID]];
	NSArray *songs = [query items];
	self.chosenSong = [songs firstObject];
	self.chosenSongLabel.text = self.chosenSong ?[NSString stringWithFormat:@"Song Chosen: %@", [self.chosenSong valueForProperty:MPMediaItemPropertyTitle]] : @"Song Chosen: none";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
