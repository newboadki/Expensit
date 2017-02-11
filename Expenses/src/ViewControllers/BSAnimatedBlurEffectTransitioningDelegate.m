//
//  BSAnimatedBlurEffectTransitioningDelegate.m
//  Expenses
//
//  Created by Borja Arias Drake on 07/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSAnimatedBlurEffectTransitioningDelegate.h"
#import "BSVisualEffects.h"
#import "Expensit-Swift.h"

@interface BSAnimatedBlurEffectTransitioningDelegate ()
@property (nonatomic) BOOL isSetupAnimation;
@property (nonatomic, copy) UIImage *originalImage;

@end


@implementation BSAnimatedBlurEffectTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isSetupAnimation = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isSetupAnimation = NO;
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    
    return [[PieChartPresentationController alloc] initWithPresentedViewController:presented
                                                          presentingViewController:presenting];
}



- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isSetupAnimation)
    {
        toViewController.view.userInteractionEnabled = NO;
        [transitionContext.containerView addSubview:toViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            toViewController.view.userInteractionEnabled = YES;
        }];
    }
    else
    {
        toViewController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            toViewController.view.userInteractionEnabled = YES;
        }];
    }
}


- (void)animationEnded:(BOOL) transitionCompleted
{
    
}

@end
