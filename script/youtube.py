#! /usr/bin/python
# -*- coding: utf-8 -*-

import gdata.youtube
import gdata.youtube.service


def PrintEntryDetails(entry):
    downloads.append ((entry.media.title.text, entry.GetSwfUrl()))
    # print 'Video title: %s (%s)' % entry.media.title.text
    # print 'Video published on: %s ' % entry.published.text
    # print 'Video description: %s' % entry.media.description.text
    # print 'Video category: %s' % entry.media.category[0].text
    # print 'Video tags: %s' % entry.media.keywords.text
    # print 'Video watch page: %s' % entry.media.player.url
    # print 'Video flash player URL: %s' % entry.GetSwfUrl()
    # print 'Video duration: %s' % 
    
  # non entry.media attributes
    # print 'Video geo location: %s' % entry.geo.location()
    # print 'Video view count: %s' % entry.statistics.view_count
    # print 'Video rating: %s' % entry.rating.average

  # show alternate formats
    # for alternate_format in entry.media.content:
    #     if 'isDefault' not in alternate_format.extension_attributes:
    #         print 'Alternate format: %s | url: %s ' % (alternate_format.type,
    #                                                    alternate_format.url)
    # # show thupmbnais
    # for thumbnail in entry.media.thumbnail:
    #     print 'Thumbnail url: %s' % thumbnail.url


def PrintVideoFeed(feed):
    for entry in feed.entry:
        PrintEntryDetails(entry)


def GetAndPrintStandardFeed():
    yt_service = gdata.youtube.service.YouTubeService()
    PrintVideoFeed(yt_service.GetTopRatedVideoFeed())
    PrintVideoFeed(yt_service.GetMostViewedVideoFeed())
    PrintVideoFeed(yt_service.GetRecentlyFeaturedVideoFeed())
    PrintVideoFeed(yt_service.GetWatchOnMobileVideoFeed())
    PrintVideoFeed(yt_service.GetTopFavoritesVideoFeed())
    PrintVideoFeed(yt_service.GetMostRecentVideoFeed())
    PrintVideoFeed(yt_service.GetMostDiscussedVideoFeed())
    PrintVideoFeed(yt_service.GetMostLinkedVideoFeed())
    PrintVideoFeed(yt_service.GetMostRespondedVideoFeed())

  # You can also retrieve a YouTubeVideoFeed by passing in the URI
    uri = 'http://gdata.youtube.com/feeds/api/standardfeeds/JP/most_viewed'
    PrintVideoFeed(yt_service.GetYouTubeVideoFeed(uri))


def SearchAndPrint(search_terms):
    yt_service = gdata.youtube.service.YouTubeService()
    query = gdata.youtube.service.YouTubeVideoQuery()
    query.vq = search_terms
    query.orderby = 'viewCount'
    query.racy = 'include'
    feed = yt_service.YouTubeQuery(query)
    PrintVideoFeed(feed)


#--
if __name__ == '__main__':
    import sys

    downloads = []
    yt_service = gdata.youtube.service.YouTubeService()
    
    yt_service.email = 'EMAIL'
    yt_service.password = 'PASSWORD'
    yt_service.source = 'my-example-application'
    yt_service.developer_key = 'DEVELP-KEY'
    yt_service.client_id = 'CLIENT_ID'
    yt_service.ProgrammaticLogin()
    
    SearchAndPrint('king crimson')
    for title, url in downloads:
        print u"%s\t%s" % (unicode (title, 'utf-8'), url)
    sys.exit()
