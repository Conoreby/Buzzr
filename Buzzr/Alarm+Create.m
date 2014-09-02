//
//  Alarm+Create.m
//  Buzzr
//
//  Created by Conor Eby on 11/25/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "Alarm+Create.h"

@implementation Alarm (Create)

+ (Alarm *)createAlarmWithID: (NSDate *)ID inManagedObjectContext: (NSManagedObjectContext *)context
{
	Alarm *alarm = nil;
	
	//Round down the milliseconds
	NSInteger timeSinceRef = [ID timeIntervalSinceReferenceDate];
	NSDate *formattedID = [NSDate dateWithTimeIntervalSinceReferenceDate:timeSinceRef];
	
	if (ID) {
		NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Alarm"];
		request.predicate = [NSPredicate predicateWithFormat:@"alarmid = %@", formattedID];
		NSError *error;
		NSArray *matches = [context executeFetchRequest:request error:&error];
		if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            alarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm"
												  inManagedObjectContext:context];
            alarm.alarmid = formattedID;
			
        } else {
            alarm = [matches lastObject];
        }
    }
    
    return alarm;
}

@end
