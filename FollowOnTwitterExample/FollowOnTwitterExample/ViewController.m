//
//  ViewController.m
//  FollowOnTwitterExample
//
//  Created by Pires on 5/20/15.
//  Copyright (c) 2015 PerpetualApps. All rights reserved.
//

#import "ViewController.h"
#import "FollowOnTwitter.h"

@interface ViewController (){
    IBOutlet UIButton *followButton;
    FollowOnTwitter *followOnTwitter;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)followOnTwitter:(id)sender{
    
    followOnTwitter = [[FollowOnTwitter alloc]init];
    followOnTwitter.twitterHandle = @"Gabe_A_Pires";
    followOnTwitter.view = self.view;
    [followOnTwitter followMe];
    
}
@end
