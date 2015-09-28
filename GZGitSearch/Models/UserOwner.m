//
//  UserOwner.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "UserOwner.h"

#import "Utils.h"

static NSString * keyAvatarUrl = @"avatar_url";
static NSString * keyId = @"id";
static NSString * keyUserName = @"login";
static NSString * keyUserPageUrl = @"html_url";
static NSString * keyFollowers = @"followers_url";

@implementation UserOwner

@synthesize userAvatarUrl;
@synthesize userId;
@synthesize userName;
@synthesize userPageUrl;
@synthesize userImage;
@synthesize userFollowers;

- (UserOwner *)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        userAvatarUrl = [Utils getStringFrom:[dic objectForKey:keyAvatarUrl]];
        userId = [Utils getNumberFrom:[dic objectForKey:keyId]];
        userName = [Utils getStringFrom:[dic objectForKey:keyUserName]];
        userPageUrl = [Utils getStringFrom:[dic objectForKey:keyUserPageUrl]];
        userFollowers = [Utils getStringFrom:[dic objectForKey:keyFollowers]];
    }
    return self;
}

@end
