#!/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'Tual'

#How to invoke from cli:
#python3 index.py <siteId>
#ex : python3 index.py 72

import requests
import sys
from datetime import date
import gspread
import pdb

api_key = 'b621c59ea7f70907b3da0d6afff890f8'
#base_url = 'http://report2.dcmn.com/index.php?module=API'
base_url = 'http://report2.dcmn.com/index.php?module=API'
time_range = '&period=range'
format_to_json = '&format=JSON'
end_date = date.fromordinal(date.today().toordinal()-1)
start_date = date.fromordinal(end_date.toordinal()-7)
date_range = start_date.strftime('%Y-%m-%d') + ',' + end_date.strftime('%Y-%m-%d')
msg = []


def get_excel_sheet_piwik_sites():
    gc = gspread.login('google@dcmn.com', 'Login;1234')
    sh = gc.open('PiwikSites')
    worksheet = sh.get_worksheet(0)
    list_of_lists = worksheet.get_all_values()
    del list_of_lists[0] #delete header
    return list_of_lists

def get_all_websites():
    r = requests.get('http://report2.dcmn.com/index.php?module=API&method=SitesManager.getAllSites&format=JSON&token_auth=b621c59ea7f70907b3da0d6afff890f8')
    #pdb.set_trace()
    return r.json()


#General purpose request function. Is not so general after all.
def request_datas(idsite, api_method):
    url_call = base_url + api_method + '&idSite=' + idsite + time_range + '&date=' + date_range + format_to_json + '&token_auth=' + api_key
    resp = requests.get(url_call)
    return resp.json()

#get all the goals and their id
def get_goals_for_website(idsite):
    api_method = '&method=Goals.getGoals'
    resp = request_datas(idsite, api_method)
    return resp.keys()

#get the number of visits for yesterday.
def get_yesterdays_visits(idsite):
    api_method = '&method=VisitsSummary.getVisits'
    url_call = base_url + api_method + '&idSite=' + idsite + '&period=day' + '&date=yesterday' + format_to_json + '&token_auth=' + api_key
    return requests.get(url_call).json()['value']

#get all the goals and their results for yesterday
def get_yesterdays_goal(idsite, goals_keys):
    api_method = '&method=Goals.get'
    dict_goals = {} # creating empty dic to populate it with only goal id + result
    for keys in goals_keys:
        url_call = base_url + api_method + '&idSite=' + idsite + '&period=day' + '&date=yesterday' + '&idGoal=' + keys + format_to_json + '&token_auth=' + api_key
        resp = requests.get(url_call).json()
        dict_goals.update({keys : int(resp['nb_conversions'])})
    return dict_goals


def make_average_visitors(idsite):
    api_method = '&method=VisitsSummary.getVisits'
    resp = request_datas(idsite, api_method)
    return int((resp['value'])/7)#I set 7 days timerange in end_date



def make_average_goals(idsite, goals_keys):
    api_method = '&method=Goals.get'
    dict_goals = {}# creating empty dic to populate it with only goal id + average conversion for last 7 days
    for keys in goals_keys:
        url_call = base_url + api_method + '&idSite=' + idsite + time_range + '&date=' + date_range + '&idGoal=' + keys + format_to_json + '&token_auth=' + api_key
        resp = requests.get(url_call).json()
        dict_goals.update({keys : int((resp['nb_conversions'])/7)})#populating
    return dict_goals


#checking diff to only get alerts when sh*t hits the fan. Percentages are probably not a good idea.
def get_diff_in_percent(avg_metric, yesterday_metric):
    if yesterday_metric > 0 and avg_metric>0:
        in_percent = (yesterday_metric*100)/avg_metric
        return 100 - in_percent
    else:
        return 100


def compare_yesterdays_goals(idsite, flag_diff):
    all_goals_for_website = get_goals_for_website(idsite)
    avg_goals = make_average_goals(idsite, all_goals_for_website)
    yesterday_goal = get_yesterdays_goal(idsite, all_goals_for_website)
    for k, avg_number in avg_goals.items():
        for y, yesterday_number in yesterday_goal.items(): #unpacking the dictionnary (goal, number)
            if k == y:
                if yesterday_number < avg_number and get_diff_in_percent(avg_number, yesterday_number) > flag_diff: #if diff > than 20%
                    name_of_website= get_name_from_id(idsite)
                    msg.append("Alert, something is wrong with the goal number " + k + ' on website ' + name_of_website + ' (goal average : ' + str(avg_number) + ' vs. yesterday : ' + str(yesterday_number) + ')') #populate msg list with error message


def compare_yesterdays_visit(idsite, flag_diff):
    avg_visits = make_average_visitors(idsite)
    yesterdays_visits = get_yesterdays_visits(idsite)
    diff_in_percent = get_diff_in_percent(avg_visits, yesterdays_visits)
    name_of_website= get_name_from_id(idsite)
    if avg_visits > yesterdays_visits and diff_in_percent > flag_diff: # same
        msg.append('Less visits than average for website ' + name_of_website + ' (on average : ' + str(avg_visits) + ' vs. yesterday: ' + str(yesterdays_visits) + ')')

def get_all_websites_by_id():
    r = requests.get('http://report2.dcmn.com/index.php?module=API&method=SitesManager.getAllSites&format=JSON&token_auth=b621c59ea7f70907b3da0d6afff890f8')
    json_answer =  r.json()
    list_of_websites = sorted(json_answer.keys())
    return list_of_websites


def get_name_from_id(idsite):
    all = get_all_websites()
    id_plus_name = [[l['name'], l['idsite']] for l in all.values()]
    for elems in id_plus_name:
        if elems[1] == idsite:
            return elems[0]



if __name__ == "__main__":
    excel_list = get_excel_sheet_piwik_sites()

    #pdb.set_trace()
    api_list = get_all_websites_by_id()

    for elems in excel_list:
        #pdb.set_trace()
        try:
            if elems[2] == '0':
                pass
            elif elems[2] == '1':
                yesterday_visit = compare_yesterdays_visit(elems[0], 50) #if the site is slow traffic, I need a big diff like 50%
                yesterday_goals = compare_yesterdays_goals(elems[0], 60)
            elif elems[2] == '2':
                yesterday_visit = compare_yesterdays_visit(elems[0], 30)
                yesterday_goals = compare_yesterdays_goals(elems[0], 40)
            elif elems[2] == '3':
                yesterday_visit = compare_yesterdays_visit(elems[0], 10)
                yesterday_goals = compare_yesterdays_goals(elems[0], 20)


        except AttributeError: #still checking the visits in case the goals were not set yet
            print('Website doesn\'t exist or goals not set\n' + '\n'.join(msg))
        except ValueError:  # includes simplejson.decoder.JSONDecodeError
            print('Decoding JSON has failed')
        except requests.exceptions.ConnectionError: #requests module's error class
            print('The API could not be reached')

    if len(msg) > 0: #if the msg list was populated with error messages
                r = '\n'.join(msg)
                sys.exit(r)


#23288
#2132
