//
//  JYTiwterUSERIDViewController.m
//  JYGetUserID_Facebook_Twitter
//
//  Created by Jeffery on 2014/8/20.
//  Copyright (c) 2014年 Jeffery. All rights reserved.
//

#import "JYTiwterUSERIDViewController.h"
#import "JYTiwterUSERIDViewModal.h"

NSString * const JYTwitterUserIDViewOAuthSccuessNotification = @"JYTwitterUserIDViewOAuthSccuessNotification";

@interface JYTiwterUSERIDViewController ()
@property (nonatomic,strong) JYTiwterUSERIDViewModal *viewModal;
@property (weak, nonatomic) IBOutlet UIButton *cancelBTN;

@property (weak, nonatomic) IBOutlet UIButton *TwitterBtn;
@property (weak, nonatomic) IBOutlet UILabel *userIDLbl;

@end

@implementation JYTiwterUSERIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewModal = [[JYTiwterUSERIDViewModal alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    @weakify(self);
    _cancelBTN.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    self.TwitterBtn.rac_command = _viewModal.getUserIDCommand;
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:JYTwitterUserIDViewOAuthSccuessNotification object:nil] subscribeNext:^(NSNotification *notification) {
        TWitterSession *session = (TWitterSession *)[notification object];
        
        _userIDLbl.text = session.userID;
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
