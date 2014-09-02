//
//  Alarm+Create.h
//  Buzzr
//
//  Created by Conor Eby on 11/25/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "Alarm.h"

@interface Alarm (Create)

+ (Alarm *)createAlarmWithID: (NSDate *)ID inManagedObjectContext: (NSManagedObjectContext *)context;

@end
