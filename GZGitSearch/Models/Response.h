//
//  Response.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

/*!
 * Metodo recebe um json do response
 * Retorna um array de repositorios
 */
- (NSMutableArray *)getArRepositorysFromJson:(NSDictionary *)json;

/*!
 * Metodo recebe um json do response
 * Retorna um array de users
 */
- (NSMutableArray *)getArSubscribersFromJson:(NSDictionary *)json;

/*!
 * Metodo recebe um json do response
 * Retorna um array de users
 */
- (NSMutableArray *)getArUsersFromJson:(NSDictionary *)json;

/*!
 * Metodo recebe um json do response
 * retorna um array de objetos UserOwner com os seguidores
 */
- (NSMutableArray *)getArFollowersFromJson:(NSDictionary *)json;

/*!
 * Metodo recebe um json do response
 * retorna um array de objetos UserOwner com os que o usuario esta seguindo
 */
- (NSMutableArray *)getArFollowingFromJson:(NSDictionary *)json;

@end
