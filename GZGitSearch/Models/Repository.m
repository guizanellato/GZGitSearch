//
//  Repository.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "Repository.h"

#import "Utils.h"

static NSString * keyDescription = @"description";
static NSString * keyId = @"id";
static NSString * keyLanguage = @"language";
static NSString * keyName = @"full_name";
static NSString * keyViewsCount = @"watchers_count";
static NSString * keyUserOwner = @"owner";
static NSString * keySubscribers = @"subscribers_url";

@implementation Repository

@synthesize repositoryDescription;
@synthesize repositoryId;
@synthesize repositoryLanguage;
@synthesize repositoryName;
@synthesize repositoryViewsCount;
@synthesize userOwner;
@synthesize repositorySubscribers;

- (Repository *)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        repositoryDescription = [Utils getStringFrom:[dic objectForKey:keyDescription]];
        repositoryId = [Utils getNumberFrom:[dic objectForKey:keyId]];
        repositoryLanguage = [Utils getStringFrom:[dic objectForKey:keyLanguage]];
        repositoryName = [Utils getStringFrom:[dic objectForKey:keyName]];
        repositoryViewsCount = [Utils getNumberFrom:[dic objectForKey:keyViewsCount]];
        repositorySubscribers = [Utils getStringFrom:[dic objectForKey:keySubscribers]];
        
        userOwner = [[UserOwner alloc] initWithDictionary:[dic objectForKey:keyUserOwner]];
    }
    return self;
}

@end
