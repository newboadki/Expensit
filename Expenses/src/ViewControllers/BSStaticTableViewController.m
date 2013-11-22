//
//  BSAddEntryViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 25/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewController.h"
#import "DateTimeHelper.h"
#import "BSEntryTextDetail.h"
#import "BSEntryDateCell.h"
#import "BSEntrySegmentedOptionCell.h"
#import "BSEntryDetailSingleButtonCell.h"
#import "BSConstants.h"
#import "BSCoreDataController.h"
#import "BSStaticTableViewSectionInfo.h"
#import "BSStaticTableViewCellInfo.h"

#import "BSStaticTableViewCellAction.h"
#import "BSStaticTableViewAbstractAction.h"
#import "BSStaticTableViewCellAction.h"
#import "BSStaticTableViewToggleExpandableCellsAction.h"
#import "BSStaticTableViewCellChangeOfValueEvent.h"
#import "BSStaticTableViewDismissYourselfAction.h"

@interface BSPendingTableViewActions : NSObject

@property (nonatomic, strong) NSMutableDictionary *actionsForIndexPath;

- (void)addAction:(BSStaticTableViewAbstractAction *)action forIndexPath:(NSIndexPath *)indexPath;

- (void)removeAction:(BSStaticTableViewAbstractAction *)action forIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)actionsForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BSPendingTableViewActions

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _actionsForIndexPath = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}



#pragma mark - Public Interface

- (void)addAction:(BSStaticTableViewAbstractAction *)action forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currentActionsForIndexPath = self.actionsForIndexPath[indexPath];
    
    if (![currentActionsForIndexPath containsObject:action])
    {
        if (!currentActionsForIndexPath)
        {
            currentActionsForIndexPath = [[NSMutableArray alloc] initWithObjects:action, nil];
            self.actionsForIndexPath[indexPath] = currentActionsForIndexPath;
        }
        else
        {
            [currentActionsForIndexPath addObject:action];
        }
    }
}


- (void)removeAction:(BSStaticTableViewAbstractAction *)action forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currentActionsForIndexPath = self.actionsForIndexPath[indexPath];
    [currentActionsForIndexPath removeObject:action];
}


- (NSArray *)actionsForIndexPath:(NSIndexPath *)indexPath
{
    return self.actionsForIndexPath[indexPath];
}

@end




@interface BSStaticTableViewController ()

/*! List of index paths that have cells that are in an expanded state.*/
@property (nonatomic, strong) NSMutableArray *unfoldedCells;

/*! List of all the cell actions that have not been executed yet. The main reason
 for this could be that the actions were raised when the target cells were not visible.
 Therefore, this pending actions get removed from this array once the cells appear.*/
@property (nonatomic, strong) BSPendingTableViewActions *pendingActions;

@end


@implementation BSStaticTableViewController

#pragma mark - Dealloc

- (void)dealloc
{
}



#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.isEditingEntry)
    {
        self.title = NSLocalizedString(@"Edit entry", @"");
    }
    else
    {
        self.title = NSLocalizedString(@"Add entry", @"");
    }
        
    // Create array for expandable cells
    self.unfoldedCells = [NSMutableArray array];
    
    // Create array for pending actions
    self.pendingActions = [[BSPendingTableViewActions alloc] init];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UITableViewCell *cell in [self.tableView visibleCells])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        // Apply pending actions
        NSArray *pendingActions = [self.pendingActions actionsForIndexPath:indexPath];
        [self applyActionsInArray:pendingActions];        
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(BSStaticTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSStaticTableViewCellInfo *cellInfo = [self.cellActionDataSource cellInfoForIndexPath:indexPath];
    
    // Safe Guard
    if (![cell isKindOfClass:[BSStaticTableViewCell class]])
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The cell needs to be an instance of BSEntryDetailCell" userInfo:nil];
    }
    
    cell.indexPath = indexPath;
    
    // Configure the cell from the cell info
    [cell configureWithCellInfo:cellInfo andModel:self.entryModel];
    
    // Update the cell value convertor
    cell.valueConvertor = [self.cellActionDataSource valueConvertorForCellAtIndexPath:indexPath];
    [cell updateValuesFromModel];
    
    // Apply pending actions
    NSArray *pendingActions = [self.pendingActions actionsForIndexPath:indexPath];
    [self applyActionsInArray:pendingActions];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.unfoldedCells containsObject:indexPath])
    {
        return 250.0f;
    }
    else
    {
        return 44.0;
    }
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - UITableView Data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.cellActionDataSource sectionsInfo] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BSStaticTableViewSectionInfo *sectionInfo = (BSStaticTableViewSectionInfo *)[self.cellActionDataSource sectionsInfo][section];
    return [sectionInfo.cellClassesInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *reuseIdentifier = [[[self.cellActionDataSource cellInfoForIndexPath:indexPath] cellClass] description];
    BSStaticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        Class cellClass = NSClassFromString(reuseIdentifier);
        cell = [[cellClass alloc] init];
        cell.delegate = self;
    }
    
    return cell;
}


#pragma mark - Actions

- (IBAction) addEntryPressed:(id)sender
{
//    NSError *error = nil;
//    if ([self saveModel:&error])
//    {
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't save" message:[error userInfo][NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
}

- (IBAction) cancelButtonPressed:(id)sender
{
//    if (self.isEditingEntry)
//    {
//        [self.coreDataController discardChanges];
//    }
//    else
//    {
//        [self.coreDataController deleteModel:self.entryModel];
//        [self.coreDataController saveChanges];
//    }
//    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) saveModel:(NSError **)error
{
    return YES;
//    return [self.coreDataController saveEntry:self.entryModel error:error];
}



#pragma mark - UITextFieldDelegate

- (void) textFieldShouldreturn
{
//    NSError *error = nil;
//    if ([self saveModel:&error])
//    {
//        if (!self.isEditingEntry)
//        {
//            self.entryModel = [self.coreDataController newEntry];
//            [self.tableView reloadData];
//        }
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't save" message:[error userInfo][NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
}



#pragma mark - EntryDetailCellDelegateProtocol

- (void)cell:(UITableViewCell *)cell eventOccurred:(BSStaticTableViewCellAbstractEvent *)event
{
    NSArray *actions = [self.cellActionDataSource actionsForEvent:event inCellAtIndexPath:event.indexPath];
    [self applyActionsInArray:actions];
}



#pragma mark - Event handling helpers

- (void)applyActionsInArray:(NSArray *)actions
{
    for (BSStaticTableViewAbstractAction *action in actions)
    {
        if ([action isKindOfClass:[BSStaticTableViewCellAction class]])
        {
            [self applyTableViewCellAction:(BSStaticTableViewCellAction *)action];
        }
        else if ([action isKindOfClass:[BSStaticTableViewToggleExpandableCellsAction class]])
        {
            [self applyToggleExpandableCellsAction:(BSStaticTableViewToggleExpandableCellsAction *)action];
        }
        else if ([action isKindOfClass:[BSStaticTableViewDismissYourselfAction class]])
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)applyTableViewCellAction:(BSStaticTableViewCellAction *)action
{
    for (NSIndexPath *ip in action.indexPathsOfCellsToPerformActionOn)
    {
        BSStaticTableViewCell *cellToPerformActionOn = (BSStaticTableViewCell *)[self.tableView visibleCells][ip.row];
        if (cellToPerformActionOn)
        {
            [cellToPerformActionOn performSelector:action.selector withObject:action.object];
            [self.pendingActions removeAction:action forIndexPath:ip];
        }
        else
        {
            [self.pendingActions addAction:action forIndexPath:ip];
        }
    }
}

- (void)applyToggleExpandableCellsAction:(BSStaticTableViewToggleExpandableCellsAction *)action
{
    for (NSIndexPath *ip in action.indexPaths)
    {
        BSStaticTableViewCell *cell = (BSStaticTableViewCell *)[self.tableView cellForRowAtIndexPath:ip];
        if ([self.unfoldedCells containsObject:ip])
        {
            [cell performSelector:@selector(setUpForFoldedState)];
            [self.unfoldedCells removeObject:ip];
        }
        else
        {
            if ([cell conformsToProtocol:@protocol(BSTableViewExpandableCell)])
            {
                [cell performSelector:@selector(setUpForUnFoldedState)];
                [self.unfoldedCells addObject:ip];
                
                for (UITableViewCell *c in self.tableView.visibleCells)
                {
                    [c resignFirstResponder];
                }
            }
        }
    }
    
    // Animate the cells
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end