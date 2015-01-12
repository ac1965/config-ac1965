#! /usr/bin/python
# -*- coding: utf-8 -*-

# picasaweb.py -e tjy1965.2010 -p taka32me -a 201008 -d 201008/

import imp
import optparse
import sys
import os

description = ""
usage = "Usage: picaweb.py --email=EMAIL_ADDRESS --password=PASSWD --album=ALBUM --dirs=UPLOAD"
parser = optparse.OptionParser(description=description, usage=usage)

parser.add_option("-e", "--email",
                  dest="email_address",
                  help="Picasa access email-address",
                  metavar="EMAIL_ADDRESS")
parser.add_option("-p", "--password",
                  dest="password",
                  help="Picasa access password",
                  metavar="PASSWORD")

opts, pargs = parser.parse_args(args=sys.argv[1:])

#if len(pargs) < 2:
#    parser.error("missing required args")

email = opts.email_address
password = opts.password

import gdata.photos.service
import gdata.media
import gdata.geo

def main():
    gd_client = gdata.photos.service.PhotosService()
    gd_client.email = email
    gd_client.password = password
    gd_client.source = 'Picasa-AutoUploadApp'
    #print u'Picasaへのログインを開始します。(%s/%s)' % (email, password)
    print u'Picasa login %s/%s' % (email, password)
    gd_client.ProgrammaticLogin()

    albums = gd_client.GetUserFeed(user=email)
    match = 0
    for a in albums.entry:
        print 'Album title = %s' % a.title.text

if __name__ == '__main__':
    sys.exit(main())
