#import "Kiwi.h"
#import "BSMonthlyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"

SPEC_BEGIN(BSMonthlySummaryViewControllerSpecs)

__block CoreDataStackHelper *coreDataStackHelper = nil;
__block BSCoreDataController *coreDataController = nil;
__block BSMonthlyExpensesSummaryViewController *monthlyViewController = nil;

beforeAll(^{
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    monthlyViewController = [[BSMonthlyExpensesSummaryViewController alloc] init];
    KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
    [monthlyViewController stub:@selector(collectionView) andReturn:collectionMock];

    monthlyViewController.coreDataStackHelper = coreDataStackHelper;
    monthlyViewController.coreDataController = coreDataController;
    
    // 2013
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"9.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"-90.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2013"] description:@"Salary" value:@"23.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2013"] description:@"Food and drinks" value:@"4" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"50.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2013"] description:@"Food and drinks" value:@"-12.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2013"] description:@"Food and drinks" value:@"-70.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2013"] description:@"Food and drinks" value:@"-60.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2013"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2013"] description:@"Food and drinks" value:@"-33.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2013"] description:@"Food and drinks" value:@"-2.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/10/2013"] description:@"Food and drinks" value:@"-7.8" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"18.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"3.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"2.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2013"] description:@"Food and drinks" value:@"10.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2013"] description:@"Food and drinks" value:@"-10.1" category:nil];
    
    // 2012
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2012"] description:@"Food and drinks" value:@"-5.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"11/07/2012"] description:@"Food and drinks" value:@"30" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Food and drinks" value:@"7" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"20/07/2012"] description:@"Food and drinks" value:@"-1.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/07/2012"] description:@"Food and drinks" value:@"-12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"22/08/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/09/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/11/2012"] description:@"Food and drinks" value:@"260.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2012"] description:@"Food and drinks" value:@"50.5" category:nil];
    
    // 2011
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/02/2011"] description:@"Food and drinks" value:@"220.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2011"] description:@"Food and drinks" value:@"2" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"06/03/2011"] description:@"Food and drinks" value:@"-1" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/04/2011"] description:@"Food and drinks" value:@"50.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"17/05/2011"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"18/06/2011"] description:@"Food and drinks" value:@"20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Food and drinks" value:@"-10" category:nil];
    
});

describe(@"Category filtering", ^{

    __block Tag* foodTag;
    __block Tag* billsTag;
    __block Tag* travelTag;
    
    beforeAll(^{
        
        NSArray *tags = @[@"Food", @"Bills", @"Travel"];
        [coreDataController createTags:tags];
        foodTag = [coreDataController tagForName:@"Food"];
        billsTag = [coreDataController tagForName:@"Bills"];
        travelTag = [coreDataController tagForName:@"Travel"];

        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Food and drinks" value:@"-50" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"China trip" value:@"-1000" category:travelTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"23/07/2011"] description:@"Food and drinks" value:@"-25" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Electricity" value:@"-10" category:billsTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/10/2012"] description:@"Food and drinks" value:@"-5" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"21/12/2011"] description:@"Rent" value:@"-10" category:billsTag];
    });
    
    
    it(@"Only take into account entries from the specified category", ^{
        [monthlyViewController filterChangedToCategory:foodTag];
        NSArray *monthlyResults = monthlyViewController.fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicateJuly = [NSPredicate predicateWithFormat:@"month = %@", (NSNumber *)[NSDecimalNumber decimalNumberWithString:@"7"]];
        NSPredicate *predicateOctober = [NSPredicate predicateWithFormat:@"month = %@", (NSNumber *)[NSDecimalNumber decimalNumberWithString:@"10"]];
        NSArray *resultsJuly =  [[monthlyResults filteredArrayUsingPredicate:predicateJuly] lastObject];
        NSArray *resultsOctober =  [[monthlyResults filteredArrayUsingPredicate:predicateOctober] lastObject];

        [[theValue([monthlyResults count]) should] equal:theValue(2)];
        [[[resultsJuly valueForKey:@"monthlySum"] should] equal:@(-75)];
        [[[resultsOctober valueForKey:@"monthlySum"] should] equal:@(-5)];
    });
});




SPEC_END