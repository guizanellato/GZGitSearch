//
//  UserOwner.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserOwner : NSObject

@property (nonatomic, strong) NSString * userAvatarUrl;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userPageUrl;
@property (nonatomic, strong) NSString * userFollowers;
@property (nonatomic, strong) NSString * userFollowing;

@property (nonatomic, strong) UIImage *userImage;

/*!
 * Metodo recebe um NSDictionary de usuario
 * Retorna um objeto do tipo UserOwner
 */
- (UserOwner *)initWithDictionary:(NSDictionary *)dic;

@end
