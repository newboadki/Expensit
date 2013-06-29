//
//  BSAppDelegate.m
//  Expenses
//
//  Created by Borja Arias Drake on 21/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSAppDelegate.h"
#import "CoreDataStackHelper.h"
#import "BSBaseExpensesSummaryViewController.h"
#import "BSCoreDataController.h"

@implementation BSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.coreDataHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                     resourceName:@"Expenses"
                                                                        extension:@"momd"];
    
//    BSCoreDataController* dataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry"
//                                                                                   delegate:nil
//                                                                             coreDataHelper:self.coreDataHelper];
    

//    [dataController insertNewEntry:@"21/01/2013" description:@"Food and drinks" value:@"-20.5"];
//    [dataController insertNewEntry:@"21/02/2013" description:@"Food and drinks" value:@"220.5"];
//    [dataController insertNewEntry:@"21/03/2013" description:@"Food and drinks" value:@"260.5"];
//    [dataController insertNewEntry:@"21/04/2013" description:@"Food and drinks" value:@"50.5"];
//    [dataController insertNewEntry:@"21/07/2013" description:@"Food and drinks" value:@"-30.5"];
//    [dataController insertNewEntry:@"21/08/2013" description:@"Food and drinks" value:@"-20.5"];
//    [dataController insertNewEntry:@"21/09/2013" description:@"Food and drinks" value:@"-20.5"];
//    [dataController insertNewEntry:@"21/10/2013" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/11/2013" description:@"Food and drinks" value:@"-20.5"];
//    [dataController insertNewEntry:@"21/12/2013" description:@"Food and drinks" value:@"-20.5"];
//    
//    [dataController insertNewEntry:@"21/01/2012" description:@"Food and drinks" value:@"-09.5"];
//    [dataController insertNewEntry:@"21/02/2012" description:@"Food and drinks" value:@"-60.5"];
//    [dataController insertNewEntry:@"21/03/2012" description:@"Food and drinks" value:@"-20.5"];
//    [dataController insertNewEntry:@"21/04/2012" description:@"Food and drinks" value:@"-30.5"];
//    [dataController insertNewEntry:@"21/05/2012" description:@"Food and drinks" value:@"30.5"];
//    [dataController insertNewEntry:@"21/06/2012" description:@"Food and drinks" value:@"30.5"];
//    [dataController insertNewEntry:@"21/07/2012" description:@"Food and drinks" value:@"-30.5"];
//    [dataController insertNewEntry:@"21/08/2012" description:@"Food and drinks" value:@"30.5"];
//    [dataController insertNewEntry:@"21/09/2012" description:@"Food and drinks" value:@"-30.5"];
//    [dataController insertNewEntry:@"22/11/2012" description:@"Flip flops" value:@"30.0"];
//    [dataController insertNewEntry:@"15/12/2012" description:@"Food" value:@"17.5"];
//    
//    [dataController insertNewEntry:@"21/01/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/04/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/05/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/06/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/07/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/08/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"21/09/2011" description:@"Food and drinks" value:@"-10.5"];
//    [dataController insertNewEntry:@"15/12/2011" description:@"Food" value:@"17.5"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataHelper saveContext];
}



@end
