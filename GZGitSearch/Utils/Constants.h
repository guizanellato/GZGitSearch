//
//  Constants.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*
 * URL usada pelo Reachability para testar a conexao
 */
#define URL_TEST_WIFI @"http://www.google.com"

/*
 * Define para buscar Localizable Strings
 */
#define LS(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#endif /* Constants_h */
