#import "Kiwi.h"
#import "BSDailyExpensesSummaryViewController.h"
#import "CoreDataStackHelper.h"
#import "BSCoreDataController.h"
#import "DateTimeHelper.h"
#import "Tag.h"

SPEC_BEGIN(BSDailySummaryViewControllerSpecs)

__block CoreDataStackHelper *coreDataStackHelper = nil;
__block BSCoreDataController *coreDataController = nil;
__block BSDailyExpensesSummaryViewController *dailyViewController = nil;

beforeAll(^{
    coreDataStackHelper = [[CoreDataStackHelper alloc] initWithPersitentStoreType:NSSQLiteStoreType resourceName:@"Expenses" extension:@"momd" persistentStoreName:@"myTestDataBase"];
    [coreDataStackHelper destroySQLPersistentStoreCoordinator];
    
    coreDataController = [[BSCoreDataController alloc] initWithEntityName:@"Entry" delegate:nil coreDataHelper:coreDataStackHelper];
    dailyViewController = [[BSDailyExpensesSummaryViewController alloc] init];
    KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
    [dailyViewController stub:@selector(collectionView) andReturn:collectionMock];

    dailyViewController.coreDataStackHelper = coreDataStackHelper;
    dailyViewController.coreDataController = coreDataController;
    

    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Food and drinks" value:@"-20.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"13/01/2013"] description:@"Salary" value:@"100.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Oyster card" value:@"-5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"05/03/2013"] description:@"Pizza" value:@"-10" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/01/2012"] description:@"Food and drinks" value:@"-20.5" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"21.0" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"03/03/2012"] description:@"Food and drinks" value:@"-7.0" category:nil];
    
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"12" category:nil];
    [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/06/2011"] description:@"Food and drinks" value:@"-5" category:nil];
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
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Fish and Chips" value:@"-1000" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2011"] description:@"Gasoline" value:@"-25" category:travelTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"19/07/2012"] description:@"Dinner" value:@"-30" category:foodTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Food and drinks" value:@"-5.60" category:billsTag];
        [coreDataController insertNewEntryWithDate:[DateTimeHelper dateWithFormat:nil stringDate:@"02/10/2013"] description:@"Trip" value:@"-100" category:travelTag];
    });
    
    
    beforeEach(^{
        KWMock *collectionMock = [KWMock nullMockForClass:UICollectionView.class];
        [dailyViewController stub:@selector(collectionView) andReturn:collectionMock];
    });
    
    
    it(@"Only take into account entries from the food category", ^{
        [dailyViewController filterChangedToCategory:foodTag];
        NSArray *dailyResults = dailyViewController.fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
        NSPredicate *predicate_19_July_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2012)]];
        NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
        NSArray *results_19_July_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2012] lastObject];

        [[theValue([dailyResults count]) should] equal:theValue(2)];
        [[[results_19_July_2011 valueForKey:@"dailySum"] should] equal:@(-1050)];
        [[[results_19_July_2012 valueForKey:@"dailySum"] should] equal:@(-30)];
    });
    
    it(@"Only take into account entries from the travel category", ^{
        [dailyViewController filterChangedToCategory:travelTag];
        NSArray *dailyResults = dailyViewController.fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_19_July_2011 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(19),  [NSString stringWithFormat:@"%@/%@", @(7), @(2011)]];
        NSPredicate *predicate_02_Oct_2012 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
        NSArray *results_19_July_2011 =  [[dailyResults filteredArrayUsingPredicate:predicate_19_July_2011] lastObject];
        NSArray *results_02_Oct_2012 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2012] lastObject];
        
        [[theValue([dailyResults count]) should] equal:theValue(2)];
        [[[results_19_July_2011 valueForKey:@"dailySum"] should] equal:@(-25)];
        [[[results_02_Oct_2012 valueForKey:@"dailySum"] should] equal:@(-100)];
    });

    it(@"Only take into account entries from the bills category", ^{
        [dailyViewController filterChangedToCategory:billsTag];
        NSArray *dailyResults = dailyViewController.fetchedResultsController.fetchedObjects;
        
        NSPredicate *predicate_02_Oct_2013 = [NSPredicate predicateWithFormat:@"day = %@ AND monthYear = %@", @(2),  [NSString stringWithFormat:@"%@/%@", @(10), @(2013)]];
        NSArray *results_02_Oct_2013 =  [[dailyResults filteredArrayUsingPredicate:predicate_02_Oct_2013] lastObject];
        
        [[theValue([dailyResults count]) should] equal:theValue(1)];
        [[[results_02_Oct_2013 valueForKey:@"dailySum"] should] equal:@(-5.60)];
    });

});

SPEC_END