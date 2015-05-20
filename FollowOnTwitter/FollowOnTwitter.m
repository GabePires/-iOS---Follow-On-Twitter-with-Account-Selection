//
//  FollowOnTwitter.m
//
//
//  Created by Pires on 5/20/15.
//  Copyright (c) 2015 perpetualApps. All rights reserved.
//

#import "FollowOnTwitter.h"

//need these two frameworks
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation FollowOnTwitter{
    
    //store twitter accounts
    NSArray *accountsArray;
    NSMutableArray *accountUsernames;
    
}

//the function that is called starts here.
-(void)followMe{
    
    //get access and twitter account information
    [self getAccountInfo];
    
}

-(void)getAccountInfo{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        //if we are allowed to access twitter account
        if(granted) {
            
            //get twitter accounts into array
            accountsArray = [accountStore accountsWithAccountType:accountType];
            
            //if we got accounts, fill our accountUsernames nsmutablearray with the account usernames
            if ([accountsArray count] > 0) {
                accountUsernames = [NSMutableArray array];
                for (ACAccount *account in accountsArray) {
                    [accountUsernames addObject:account.username];
                }
                
                
                [self accountSelection];
                
                /* if you want to just skip the action sheet if user has just one account
                 
                //if more than one account on device, let user choose which account to select
                //if just one account, use that as default.
                if([accountsArray count] > 1){
                    //display the uiaction sheet to choose which account to use
                    [self accountSelection];
                }
                else{
                    [self followOnTwitter:0];
                }
                 
                */
                
                
            }
            else {
                [self twitterUnavailable];
            }
            
        }
    }];
}
-(void)twitterUnavailable{
    //handle errors if no twitter account available.
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Twitter Unavailable" message: @"We don't detect any twitter accounts on your phone. Please Log into Twitter first via settings!" delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorAlert show];
}
-(void)accountSelection{
    //our UIActionSheet: dynamically adds 'otherButtonTitle' for every Twitter account we discover.
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an account"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    //we use grand central dispatch multithread to separate
    //getting the usernames and displaying the Actionsheet UI.
    //otherwise the Actionsheet/App will lag until the data portion is completed
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //enumerate through our usernames and add @ - just to make these look more like Twitter handles
        for (NSString __strong *username in accountUsernames) {
            NSString *twitterHandle = @"@";
            username = [twitterHandle stringByAppendingString:username];
            
            //add @username to the uiactionsheet
            [actionSheet addButtonWithTitle:username];
            NSLog(@"%@", username);
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            //display the Actionsheet.
            [actionSheet showInView:_view];
            
        });
    });
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //order of buttons will match order of NSArray
    //NSArray order is maintained
    [self followOnTwitter:buttonIndex];
}

-(void)followOnTwitter:(NSInteger)index{
    // Grab the initial Twitter account to tweet from.
    ACAccount *twitterAccount = [accountsArray objectAtIndex:index];
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:_twitterHandle forKey:@"screen_name"];
    [tempDict setValue:@"true" forKey:@"follow"];
    
    //requestForServiceType
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"] parameters:tempDict];
    [postRequest setAccount:twitterAccount];
    
    //Again, we use grand central dispatch to separate data from UI.
    //Without this technique, we will experience a lot of delay and hinder user experience.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            [self successFollow];
            
        }];
        dispatch_async(dispatch_get_main_queue(),^{
            [self thanksForFollowing];
        });
    });
}

-(void)successFollow{
    //handle the data for successfully following us on Twitter
    NSLog(@"Successfully followed, handle data here in backround thread.");
    
}

-(void)thanksForFollowing{
    //handle the UI for saying thanks to the user.
    UIAlertView *thanksAlert = [[UIAlertView alloc] initWithTitle:@"Success! " message:@"Thanks for following!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [thanksAlert show];
}
@end
