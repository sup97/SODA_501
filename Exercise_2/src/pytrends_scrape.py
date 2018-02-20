# -*- coding: utf-8 -*-
"""
Scraping Google Trends Data

Created on Thurs Feb 1 20:57:01 2018

@author: Claire Kelling

The purpose of this file is to scrape terrorism related files.

"""

#  set working directory
import os
from pytrends.request import TrendReq

os.chdir('C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/'
         'SODA_501/Exercise_2/')


# Login to Google. Only need to run this once, the rest of requests will use
#    the same session.
pytrend = TrendReq()

# Create payload and capture API tokens. Only needed for interest_over_time(),
#     interest_by_region() & related_queries()
list_terr = ["Al Qaeda", "Terrorism", "Terror", "Attack", "Iraq",
             "Afghanistan", "Iran", "Pakistan", "Agro",
             "Environmental Terrorism", "Eco-Terrorism", "Conventional Weapon",
             "Weapons Grade", "Dirty Bomb", "Nuclear Enrichment", "Nuclear",
             "Chemical Weapon", "Biological Weapon", "Ammonium nitrate",
             "Improvised Explosive Device", "Abu Sayyaf", "Hamas", "FARC",
             "Irish Republican Army", "Euskadi ta Askatasuna", "Hezbollah",
             "Tamil Tigers", "PLO", "Palestine", "Liberation Front",
             "Car bomb", "Jihad", "Taliban", "Suicide bomber",
             "Suicide attack", "AL Qaeda in the Arabian Peninsula",
             "Al Qaeda in the Islamic Maghreb", "Tehrik-i-Taliban Pakistan",
             "Yemen", "Pirates", "Extremism", "Somalia", "Nigeria",
             "Political radicalism", "Al-Shabaab", "Nationalism",
             "Recruitment", "Fundamentalism", "Islamist"]


pytrend.build_payload(kw_list=list_terr[0:5], timeframe='all', geo='US')

# Interest Over Time, change "dfi"
interest_over_time_df = pytrend.interest_over_time()


tot_term = [interest_over_time_df]

print(interest_over_time_df.head())

interest_over_time_df.to_csv('tot_topics.csv')
