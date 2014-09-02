//
//  AlarmCDTVC.h
//  Buzzr
//
//  Created by Conor Eby on 11/24/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface AlarmCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
