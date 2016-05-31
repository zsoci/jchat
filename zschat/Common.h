//
//  Common.h
//  zschat
//
//  Created by Zsolt Laky on 2014. 12. 07..
//  Copyright (c) 2014. Zsolt Laky. All rights reserved.
//

#ifndef zschat_Common_h
#define zschat_Common_h

#define DEVELOPMENT
#ifdef DEVELOPMENT
//#define DEFAULTHOST     @"192.168.0.108"
#define DEFAULTHOST     @"127.0.0.1"
//#define DEFAULTHOST     @"zsoci.no-ip.biz"
#define DEFAULTPORT     8082
#else
#define DEFAULTHOST     @"game.bridgeisland.com"
#define DEFAULTPORT     80
#endif

#define APPLICATIONID   @"zschat"
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define NODE_NOT_PROCESSED      @"%s(%d): Node %@ is not processed",__PRETTY_FUNCTION__,__LINE__

#endif
