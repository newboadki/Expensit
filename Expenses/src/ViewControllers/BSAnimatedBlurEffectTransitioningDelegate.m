//
//  BSAnimatedBlurEffectTransitioningDelegate.m
//  Expenses
//
//  Created by Borja Arias Drake on 07/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSAnimatedBlurEffectTransitioningDelegate.h"
#import "BSVisualEffects.h"

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
        UIImageView *backgroundOriginalImageView = (UIImageView*)[toViewController.view viewWithTag:200];
        UIImageView *backgroundBlurredImageView = (UIImageView*)[toViewController.view viewWithTag:300];
        backgroundOriginalImageView.image = [BSVisualEffects screenshotFromView:fromViewController.view];
        self.originalImage = backgroundOriginalImageView.image;
        backgroundBlurredImageView.image = [BSVisualEffects blurredViewImageFromView:fromViewController.view];

        toViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        backgroundOriginalImageView.alpha = 1.0;
        backgroundBlurredImageView.alpha = 0.0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            backgroundOriginalImageView.alpha = 0.0;
            backgroundBlurredImageView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            toViewController.view.userInteractionEnabled = YES;
        }];
    }
    else
    {
        UIImageView *backgroundOriginalImageView_initialAnimation = (UIImageView*)[fromViewController.view viewWithTag:200];
        UIImageView *backgroundBlurredImageView_initialAnimation = (UIImageView*)[fromViewController.view viewWithTag:300];
        UIImageView *backgroundOriginalImageView = (UIImageView*)[fromViewController.view viewWithTag:400];
        UIImageView *backgroundBlurredImageView = (UIImageView*)[fromViewController.view viewWithTag:500];
        
        backgroundOriginalImageView.image = self.originalImage;
        backgroundBlurredImageView.image = [BSVisualEffects screenshotFromView:fromViewController.view];

        
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];

        backgroundOriginalImageView_initialAnimation.alpha = 0.0;
        backgroundBlurredImageView_initialAnimation.alpha = 0.0;

        backgroundOriginalImageView.alpha = 0.0;
        backgroundBlurredImageView.alpha = 1.0;

        toViewController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            backgroundOriginalImageView.alpha = 1.0;
            backgroundBlurredImageView.alpha = 0.0;

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
