//
//  AddAlarmViewController.m
//  Buzzr
//
//  Created by Conor Eby on 11/24/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "AddAlarmViewController.h"

@interface AddAlarmViewController ()

@end

@implementation AddAlarmViewController
- (IBAction)cancelAlarmAdd:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)labelChanged:(UITextField *)sender {
	self.labelText = sender.text;
}

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
	[self.labelTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseSong:(UIButton *)sender {
	[self pickSongFromLibrary];
}

- (void) pickSongFromLibrary
{
	MPMediaPickerController *controller = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
	controller.delegate = self;
	controller.allowsPickingMultipleItems = NO;
	
	
	[self presentViewController: controller animated:YES completion:NULL];
	
}

//In order to get the alarm to fire right when it turns that time, you must 0 out the
//seconds part of the date returned by the datepicker
- (IBAction)saveAlarm:(UIButton *)sender {
	Alarm *newAlarm = [Alarm createAlarmWithID:[self getAlarmId] inManagedObjectContext:self.managedObjectContext];
	newAlarm.label = self.labelText;
	newAlarm.playSong = self.chosenSong ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
	newAlarm.song = [NSString stringWithFormat:@"%qi",[[self.chosenSong valueForProperty:MPMediaItemPropertyPersistentID] longLongValue]];
	
	//Zeros out the seconds part that is randomly assigned
	NSTimeInterval time = floor([self.alarmTime.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    newAlarm.time = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
	
	//Want to make sure that the day is set to tommorow if that time has already passed
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.day = 1;
	
	if ([self.alarmTime.date compare:[NSDate date]] == NSOrderedDescending) {
		NSTimeInterval time = floor([self.alarmTime.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
		newAlarm.time = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
	} else {
		NSTimeInterval time = floor([self.alarmTime.date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
		newAlarm.time = [calendar dateByAddingComponents:components toDate:[NSDate dateWithTimeIntervalSinceReferenceDate:time] options:0];
	}

	
	
	newAlarm.vibrate = self.vibrateEnableSwitch.isOn ? [NSNumber numberWithBool:YES]	: [NSNumber numberWithBool:NO];
	newAlarm.enabled = [NSNumber numberWithBool:YES];
	newAlarm.notificationID = [NSNumber numberWithInt: arc4random() % 82];
	[self setNotificationForAlarm: newAlarm];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) setNotificationForAlarm: (Alarm *)alarm
{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	
	[localNotification setFireDate:alarm.time];
	[localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
	
	[localNotification setAlertBody:alarm.label];
	[localNotification setAlertAction:@"Alarm!"];
	[localNotification setHasAction:YES];
	
	NSDictionary *alarmIdentifier = [NSDictionary dictionaryWithObject:alarm.notificationID forKey:@"notificationID"];
	localNotification.userInfo = alarmIdentifier;
	
	[[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
}

- (NSDate *) getAlarmId
{
	return [NSDate date];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
    [textField resignFirstResponder];
    return YES;
}

//MPMediaPickerController Delegate methods

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
	//We only care about one
	self.chosenSong = [mediaItemCollection.items firstObject];
	self.chosenSongLabel.text = [NSString stringWithFormat:@"Song Chosen: %@", [self.chosenSong valueForProperty:MPMediaItemPropertyTitle]];
	[mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	[mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}


@end
