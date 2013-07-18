//
//  BSGraphViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSGraphViewController.h"

@interface BSGraphViewController ()

@end

@implementation BSGraphViewController

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
    
    
    
    

}

//- (NSArray*) moneyIn
//{
//    if (_moneyIn) {
//        return _moneyIn;
//    }
//    NSArray *moneyIn = [NSArray arrayWithObjects:@150,
//                               @160,
//                               @200,
//                               @110,
//                               @150,
//                               @175,
//                               @195,
//                               @80,
//                               @90,
//                               @80,
//                               @90,
//                               @80,nil];
//    return moneyIn;
//}
//
//- (NSArray*) moneyOut
//{
//    if (_moneyOut) {
//        return _moneyOut;
//    }
//    
//    NSArray *moneyOut = [NSArray arrayWithObjects:@10,
//                         @0,
//                         @150,
//                         @260,
//                         @10,
//                         @80,
//                         @100,
//                         @150,
//                         @180,
//                         @120,
//                         @150,
//                         @140,nil];
//;
//    return moneyOut;
//}

- (NSArray*) xValues {
    return @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


@end
