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
static NSString * keyFollowing = @"following_url";
static NSString * keyBlog = @"blog";
static NSString * keyDateCreated = @"created_at";
static NSString * keyEmail = @"email";
static NSString * keyFollowersCount = @"followers";
static NSString * keyFollowingCount = @"following";
static NSString * keyUserFullName = @"name";
static NSString * keyLastUpdate = @"updated_at";
static NSString * keyLocation = @"location";
static NSString * keyUserUrlPerfil = @"url";

@implementation UserOwner

@synthesize userAvatarUrl;
@synthesize userId;
@synthesize userName;
@synthesize userPageUrl;
@synthesize userImage;
@synthesize userFollowers;
@synthesize userFollowing;
@synthesize userBlog;
@synthesize userDateCreated;
@synthesize userEmail;
@synthesize userFollowersCount;
@synthesize userFollowingCount;
@synthesize userFullName;
@synthesize userLastUpdate;
@synthesize userLocation;
@synthesize userUrlPerfil;

- (UserOwner *)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        userAvatarUrl = [Utils getStringFrom:[dic objectForKey:keyAvatarUrl]];
        userId = [Utils getNumberFrom:[dic objectForKey:keyId]];
        userName = [Utils getStringFrom:[dic objectForKey:keyUserName]];
        userPageUrl = [Utils getStringFrom:[dic objectForKey:keyUserPageUrl]];
        userFollowers = [Utils getStringFrom:[dic objectForKey:keyFollowers]];
        userFollowing = [self removeParamFrom:[Utils getStringFrom:[dic objectForKey:keyFollowing]]];
        userBlog = [Utils getStringFrom:[dic objectForKey:keyBlog]];
        userDateCreated = [Utils getStringFrom:[dic objectForKey:keyDateCreated]];
        userEmail = [Utils getStringFrom:[dic objectForKey:keyEmail]];
        userFollowersCount = [Utils getStringFrom:[dic objectForKey:keyFollowersCount]];
        userFollowingCount = [Utils getStringFrom:[dic objectForKey:keyFollowingCount]];
        userFullName = [Utils getStringFrom:[dic objectForKey:keyUserFullName]];
        userLastUpdate = [Utils getStringFrom:[dic objectForKey:keyLastUpdate]];
        userLocation = [Utils getStringFrom:[dic objectForKey:keyLocation]];
        userUrlPerfil = [Utils getStringFrom:[dic objectForKey:keyUserUrlPerfil]];
    }
    return self;
}

- (NSString *)removeParamFrom:(NSString *)paramResponse {
    NSString * str = @"{/other_user}";
    
    NSRange textRange =[paramResponse rangeOfString:str];
    
    if(textRange.location != NSNotFound) {
        return [paramResponse stringByReplacingOccurrencesOfString:str withString:@""];
    }
    
    return paramResponse;
}

@end
