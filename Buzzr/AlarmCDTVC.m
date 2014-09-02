//
//  AlarmCDTVC.m
//  Buzzr
//
//  Created by Conor Eby on 11/24/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "AlarmCDTVC.h"
#import "AddAlarmViewController.h"
#import "EditAlarmViewController.h"

@interface AlarmCDTVC ()

@end

@implementation AlarmCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Alarm"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"alarmid"
                                                              ascending:YES]];
	
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


- (void)useDocument
{
	NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	url = [url URLByAppendingPathComponent:@"AlarmsDocument"];
	UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
		[document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			if (success) {
				self.managedObjectContext = document.managedObjectContext;
			}
			if (!success) NSLog(@"couldn't create document at %@", url);
		}];
	} else if (document.documentState == UIDocumentStateClosed) {
		[document openWithCompletionHandler:^(BOOL success) {
			if (success) {
				self.managedObjectContext = document.managedObjectContext;
			}
		}];
	} else {
		self.managedObjectContext = document.managedObjectContext;
	}
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
	UISwitch *alarmEnabled;
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Alarm Cell"];
	
	Alarm *alarm = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	
	cell.textLabel.text = [dateFormatter stringFromDate:alarm.time];
	cell.detailTextLabel.text = alarm.label;
	
	alarmEnabled = [[UISwitch alloc]
					 initWithFrame:
					 CGRectMake(1.0,1.0,20.0,20.0)];
	alarmEnabled.tag = [alarm.alarmid timeIntervalSinceReferenceDate];
	
	[alarmEnabled addTarget:self
					  action:@selector(toggleAlarmEnabledSwitch:)
			forControlEvents:UIControlEventTouchUpInside];
	
	[alarmEnabled setOn:[alarm.enabled boolValue]];
	cell.accessoryView = alarmEnabled;
	
	return cell;

}

- (void)toggleAlarmEnabledSwitch:(id)sender
{
	//Query using the the tag on the switch
	if ([sender isKindOfClass:[UISwitch class]]) {
		UISwitch *currSwitch = sender;
		NSDate *alarmID = [NSDate dateWithTimeIntervalSinceReferenceDate:currSwitch.tag];
		//Query for that alarm and set it's enabled to whatever the switch is....
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Alarm"];
		request.predicate = [NSPredicate predicateWithFormat:@"alarmid = %@", alarmID];
		NSError *error;
		Alarm *alarm = [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];
		alarm.enabled = [NSNumber numberWithBool:currSwitch.isOn];
		if (alarm.enabled) {
			[self setNotificationForAlarm: alarm];
			
		} else {
			NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
			for (UILocalNotification *notification in localNotifications){
				if (alarm.notificationID == [notification.userInfo valueForKeyPath:@"notificationID"]){
					[[UIApplication sharedApplication] cancelLocalNotification:notification];
				}
			}
		}
	}
}

-(void) setNotificationForAlarm: (Alarm *)alarm
{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	//Found how to add one day to it here: http://stackoverflow.com/questions/6094403/increase-nsdate-1-day-method-objective-c
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.day = 1;
	
	NSDate *fireDate;
	
	if ([alarm.time compare:[NSDate date]] == NSOrderedDescending) {
		fireDate = alarm.time;
	} else {
		fireDate = [calendar dateByAddingComponents:components toDate:alarm.time options:0];
		alarm.time = fireDate;
	}
	
	[localNotification setFireDate:alarm.time];
	[localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
	
	[localNotification setAlertBody:alarm.label];
	[localNotification setAlertAction:@"Alarm!"];
	[localNotification setHasAction:YES];
	
	NSDictionary *alarmIdentifier = [NSDictionary dictionaryWithObject:alarm.notificationID forKey:@"notificationID"];
	localNotification.userInfo = alarmIdentifier;
	
	[[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (!self.managedObjectContext) [self useDocument];
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
}


- (IBAction)addedAlarm:(UIStoryboardSegue *)segue
{
	//Reload core data
	[self.tableView reloadData];
	
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.destinationViewController isKindOfClass:[AddAlarmViewController class]]){
		AddAlarmViewController *destination = segue.destinationViewController;
		destination.managedObjectContext = self.managedObjectContext;
		if ([segue.identifier isEqualToString:@"editAlarm"]) {
			EditAlarmViewController *eavc = (EditAlarmViewController *)segue.destinationViewController;
			UITableViewCell *chosenCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
			eavc.alarmId = [NSDate dateWithTimeIntervalSinceReferenceDate:chosenCell.accessoryView.tag];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
