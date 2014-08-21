//
//  JYMainViewController.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/21.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "JYMainViewController.h"
#import "JYFBUSERIDViewController.h"
#import "JYTiwterUSERIDViewController.h"

@interface JYMainViewController ()
@property(nonatomic,strong) JYFBUSERIDViewController *FBUSERIDViewController;
@property(nonatomic,strong) JYTiwterUSERIDViewController *TiwterUSERIDViewController;
@end

@implementation JYMainViewController

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
    // Do any additional setup after loading the view from its nib.
    self.FBUSERIDViewController = [[JYFBUSERIDViewController alloc] init];
    self.TiwterUSERIDViewController = [[JYTiwterUSERIDViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)enterFBVIewAction:(id)sender {
    [self presentViewController:_FBUSERIDViewController animated:YES completion:nil];
}
- (IBAction)enterTWitterVIewAction:(id)sender {
    [self presentViewController:_TiwterUSERIDViewController animated:YES completion:nil];
}

@end
