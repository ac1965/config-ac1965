#! /usr/bin/python
# -*- coding: utf-8 -*-

# picasaweb.py -e tjy1965.2010 -p .aka.u._ -a 201008 -d 201008/

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
parser.add_option("-a", "--album",
                  dest="album",
                  help="album name",
                  metavar="ALBUM")
parser.add_option("-d", "--dirs",
                  dest="directory",
                  help="upload target directory",
                  metavar="DIRECTORY")

opts, pargs = parser.parse_args(args=sys.argv[1:])

#if len(pargs) < 2:
#    parser.error("missing required args")

email = opts.email_address
password = opts.password
album_name = opts.album
target_dirs = opts.directory

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

    filepath = []
    for root, dirs, files in os.walk(target_dirs):
        for f in files:
            if (f.endswith(".JPG") or f.endswith(".jpg")):
                filepath.append ((os.path.join(root, f), f))
            if (f.endswith(".MPG") or f.endswith(".mpg")):
                filepath.append ((os.path.join(root, f), f))
            if (f.endswith(".MP4") or f.endswith(".mp4")):
                filepath.append ((os.path.join(root, f), f))

    albums = gd_client.GetUserFeed(user=email)
    match = 0
    for a in albums.entry:
        if (album_name == a.title.text):
            match = 1
            target_id = a.gphoto_id.text
            break

    if match:
        #print u'既存アルバム %s に追加' % album_name
        print 'using old album %s' % album_name
    else:
        #print u'新規アルバム %s を作成' % album_name
        print 'create new album %s' % album_name
        new_album = gd_client.InsertAlbum(title=album_name, summary='')
        target_id = new_album.gphoto_id.text
       
                
    album_url = "/data/feed/api/user/default/albumid/%s" % (target_id)
    print u'URL:%s' % album_url
    for (i,(photo_path, photo_name)) in enumerate(filepath):
        print u'(%i/%i) %s .. uploading ...' % (i+1,
                                                len(filepath),
                                                photo_name
                                                )
        gd_client.InsertPhotoSimple(album_url, photo_name,
                                    '',
                                    photo_path,
                                    content_type="image/jpeg"
                                    )


if __name__ == '__main__':
    sys.exit(main())
