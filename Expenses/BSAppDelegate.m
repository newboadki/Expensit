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
#import "DateTimeHelper.h"
#import "BSGreenTheme.h"
#import "BSConstants.h"
#import "BSCoreDataFixturesManager.h"

@implementation BSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Core Data Helper
    self.coreDataHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType
                                                                     resourceName:@"Expenses"
                                                                        extension:@"momd"
                                                              persistentStoreName:@"expensesDataBase"];
 


    // Theme
    self.themeManager = [BSThemeManager manager];
    self.themeManager.theme = [[BSGreenTheme alloc] init];
    [self.themeManager applyTheme];

    // Create sample entries the first time
    if ([self isFirstTheAppEverRun])
    {
        BSCoreDataController *controller = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:self.coreDataHelper];
        [controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-300.0"];
        [controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/07/2012"] description:@"Pocket money" value:@"100.0"];
    }
    
    
    // Apply fixtures
    BSCoreDataController *coreDataController = [[BSCoreDataController alloc] init];
    coreDataController.coreDataHelper = self.coreDataHelper;
    BSCoreDataFixturesManager *manager = [[BSCoreDataFixturesManager alloc] init];
    [manager applyMissingFixturesOnManagedObjectModel:self.coreDataHelper.managedObjectModel coreDataController:coreDataController];
    
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

- (BOOL)isFirstTheAppEverRun {
    
    BOOL isFirstTime = NO;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectoryPath = nil;
    
    if ([paths count] > 0)
    {
        documentsDirectoryPath = paths[0];
        NSString* pathToFirstTimeFlag =  [documentsDirectoryPath stringByAppendingFormat:@"/%@", FIRSTTIME_FILE];
        isFirstTime = ![[NSFileManager defaultManager] fileExistsAtPath:pathToFirstTimeFlag];
        if (isFirstTime) {
            [NSKeyedArchiver archiveRootObject:@[@"firstTime"] toFile:pathToFirstTimeFlag];
        }
    }
    
    return isFirstTime;
}

@end




//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Dinner at Frankie's" value:@"-40.0"];
//        [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Car wash" value:@"-80.0"];
//        [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Went to the movies" value:@"-24.0"];
//        [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food for the week" value:@"-100.0"];
//        [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/01/2013"] description:@"Old favor" value:@"200.0"];
//        [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/01/2013"] description:@"Rent" value:@"-5000.0"];
//
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Pret" value:@"-10.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Salary" value:@"3800.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-500.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-210.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"100.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1"];
//
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5"];
//
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"01/03/2011"] description:@"Food and drinks" value:@"50"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/03/2011"] description:@"Food and drinks" value:@"-190"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2011"] description:@"Food and drinks" value:@"-50"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"04/03/2011"] description:@"Food and drinks" value:@"17"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"24.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-34.98"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"07/03/2011"] description:@"Food and drinks" value:@"-10"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"08/03/2011"] description:@"Food and drinks" value:@"20"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"09/03/2011"] description:@"Food and drinks" value:@"-17"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"10/03/2011"] description:@"Food and drinks" value:@"13"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/03/2011"] description:@"Food and drinks" value:@"22"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"12/03/2011"] description:@"Food and drinks" value:@"-18"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"14/03/2011"] description:@"Food and drinks" value:@"11"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"15/03/2011"] description:@"Food and drinks" value:@"29"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"16/03/2011"] description:@"Food and drinks" value:@"-100"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/03/2011"] description:@"Food and drinks" value:@"100"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/03/2011"] description:@"Food and drinks" value:@"235"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/03/2011"] description:@"Food and drinks" value:@"-90"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/03/2011"] description:@"Food and drinks" value:@"18"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/03/2011"] description:@"Food and drinks" value:@"21"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/03/2011"] description:@"Food and drinks" value:@"-12"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"23/03/2011"] description:@"Food and drinks" value:@"-156"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"24/03/2011"] description:@"Food and drinks" value:@"18"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"25/03/2011"] description:@"Food and drinks" value:@"-80"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"26/03/2011"] description:@"Food and drinks" value:@"-35"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"27/03/2011"] description:@"Food and drinks" value:@"-40"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"28/03/2011"] description:@"Food and drinks" value:@"99"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"29/03/2011"] description:@"Food and drinks" value:@"20"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"30/03/2011"] description:@"Food and drinks" value:@"-94"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"31/03/2011"] description:@"Food and drinks" value:@"-83"];
//
//
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5"];
//    [ controller insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10"];

