/** @file msvc_dirent.h
 *  @brief Implementation of dirent functions using WIN32 API.
 */
/*

    Declaration of POSIX directory browsing functions and types for Win32.

    Author:  Kevlin Henney (kevlin@acm.org, kevlin@curbralan.com)
    History: Created March 1997. Updated June 2003.

    Copyright Kevlin Henney, 1997, 2003. All rights reserved.

    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose is hereby granted without fee, provided
    that this copyright and permissions notice appear in all copies and
    derivatives.
    
    This software is supplied "as is" without express or implied warranty.

    But that said, if there are any problems please get in touch.

*/
    
#ifndef XAPIAN_INCLUDED_MSVC_DIRENT_H
#define XAPIAN_INCLUDED_MSVC_DIRENT_H

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct DIR DIR;

struct dirent
{
    char *d_name;
};

DIR           *opendir(const char *);
int           closedir(DIR *);
struct dirent *readdir(DIR *);
void          rewinddir(DIR *);

#ifdef __cplusplus
}
#endif

#endif // XAPIAN_INCLUDED_MSVC_DIRENT_H
