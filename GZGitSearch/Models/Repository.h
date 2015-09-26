//
//  Repository.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserOwner.h"

@interface Repository : NSObject

@property (nonatomic, strong) NSString * repositoryDescription;
@property (nonatomic, strong) NSString * repositoryName;
@property (nonatomic, strong) NSNumber * repositoryId;
@property (nonatomic, strong) NSString * repositoryLanguage;
@property (nonatomic, strong) NSNumber * repositoryViewsCount;
@property (nonatomic, strong) NSString * repositorySubscribers;

@property (nonatomic, strong) UserOwner * userOwner;

/*
 * Metodo recebe um NSDictionary com um repositorio
 * Retorna um objeto do tipo Repository
 */
- (Repository *)initWithDictionary:(NSDictionary *)dic;

@end
