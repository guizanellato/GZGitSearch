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
@property (nonatomic, strong) NSString * userFullName;
@property (nonatomic, strong) NSString * userBlog;
@property (nonatomic, strong) NSString * userLocation;
@property (nonatomic, strong) NSString * userDateCreated;
@property (nonatomic, strong) NSString * userLastUpdate;
@property (nonatomic, strong) NSString * userEmail;
@property (nonatomic, strong) NSString * userFollowersCount;
@property (nonatomic, strong) NSString * userFollowingCount;
@property (nonatomic, strong) NSString * userUrlPerfil;

/*
 * Quando a imagem do usuario ja foi baixada, ela fica armazenada nessa variavel
 */
@property (nonatomic, strong) UIImage *userImage;

/*!
 * Metodo recebe um NSDictionary de usuario
 * Retorna um objeto do tipo UserOwner
 */
- (UserOwner *)initWithDictionary:(NSDictionary *)dic;

@end
