//
//  Response.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "Response.h"

#import "Repository.h"

static NSString *keyResponseData = @"items";

@implementation Response

- (NSMutableArray *)getArRepositorysFromJson:(NSDictionary *)json {
    /*
     * Primeiro o array de itens do json é colocado na var: arData
     * Caso venha nil ou vazia, retornar um array
     * Caso venha com itens, preencher a var: arRepositorys com os repositorios do response
     */
    if (json != nil) {
        
        NSArray * arData = [json objectForKey:keyResponseData];
        
        if (arData == nil || arData.count == 0) {
            return [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *arRepositorys = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in arData) {
            [arRepositorys addObject:[[Repository alloc] initWithDictionary:dic]];
        }
        
        return arRepositorys;
    }
    
    return [[NSMutableArray alloc] init];
}

- (NSMutableArray *)getArSubscribersFromJson:(NSDictionary *)json {
    /*
     * Primeiro validacao de json diferente de nil
     * caso venha um item só no array, ele vem como NSDictionary
     * entao é feita uma validacao para isso nao acontecer
     */
    if (json != nil) {
        
        NSArray *arData;
        NSMutableArray *arSubscribers = [[NSMutableArray alloc] init];
        
        if ([json isKindOfClass:[NSArray class]]) {
            arData = (NSArray *)json;
        } else {
            arData = [[NSArray alloc] initWithObjects:json, nil];
        }
        
        if (arData == nil || arData.count == 0) {
            return [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dic in arData) {
            [arSubscribers addObject:[[UserOwner alloc] initWithDictionary:dic]];
        }
        
        return arSubscribers;
    }
    
    return [[NSMutableArray alloc] init];
}

- (NSMutableArray *)getArFollowersFromJson:(NSDictionary *)json {
    /*
     * Primeiro validacao de json diferente de nil
     * caso venha um item só no array, ele vem como NSDictionary
     * entao é feita uma validacao para isso nao acontecer
     */
    if (json != nil) {
        
        NSArray *arData;
        NSMutableArray *arFollowers = [[NSMutableArray alloc] init];
        
        if ([json isKindOfClass:[NSArray class]]) {
            arData = (NSArray *)json;
        } else {
            arData = [[NSArray alloc] initWithObjects:json, nil];
        }
        
        if (arData == nil || arData.count == 0) {
            return [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dic in arData) {
            [arFollowers addObject:[[UserOwner alloc] initWithDictionary:dic]];
        }
        
        return arFollowers;
    }
    
    return [[NSMutableArray alloc] init];
}

- (NSMutableArray *)getArFollowingFromJson:(NSDictionary *)json {
    /*
     * Primeiro validacao de json diferente de nil
     * caso venha um item só no array, ele vem como NSDictionary
     * entao é feita uma validacao para isso nao acontecer
     */
    if (json != nil) {
        
        NSArray *arData;
        NSMutableArray *arFollowing = [[NSMutableArray alloc] init];
        
        if ([json isKindOfClass:[NSArray class]]) {
            arData = (NSArray *)json;
        } else {
            arData = [[NSArray alloc] initWithObjects:json, nil];
        }
        
        if (arData == nil || arData.count == 0) {
            return [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dic in arData) {
            [arFollowing addObject:[[UserOwner alloc] initWithDictionary:dic]];
        }
        
        return arFollowing;
    }
    
    return [[NSMutableArray alloc] init];
}


- (NSMutableArray *)getArUsersFromJson:(NSDictionary *)json {
    /*
     * Primeiro o array de itens do json é colocado na var: arData
     * Caso venha nil ou vazia, retornar um array
     * Caso venha com itens, preencher a var: arUsers com os repositorios do response
     */
    if (json != nil) {
        
        NSArray * arData = [json objectForKey:keyResponseData];
        
        if (arData == nil || arData.count == 0) {
            return [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *arUsers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in arData) {
            [arUsers addObject:[[UserOwner alloc] initWithDictionary:dic]];
        }
        
        return arUsers;
    }
    
    return [[NSMutableArray alloc] init];
}

@end
