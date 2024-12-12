from adaptor import os_parser,aliyun_parser,cs_parser
from antlr import NMLCTest
import json
# openstack转成NMLC
def ospolicy2standard(ospolicy):
    resp = {}
    standard_policy = {}
    standard_policy['format'] = 'openstack'
    resp['rules'] = os_parser.ospolicy2standard(ospolicy)
    standard_policy['standard_policy']=resp
    return standard_policy
# NMLC转成openstack
def standard2ospolicy(standard_policy):
    resp = {}
    resp['format'] = 'openstack'
    resp['policy'] = os_parser.standard2ospolicy(standard_policy)
    return resp
# 阿里云转成NMLC
def aliyun2standard(aliyunpolicy):
    resp = {}
    standard_policy = {}
    standard_policy['format'] = 'aliyun'
    resp['rules'] = aliyun_parser.aliyun2standard(aliyunpolicy)
    standard_policy['standard_policy']=resp
    return standard_policy
# NMLC转成阿里云
def standard2aliyun(standard_policy):
    resp = {}
    resp['Version'] = '1'
    resp['Statement'] = aliyun_parser.standard2aliyun(standard_policy)
    return resp
# cloudstack转成NMLC
def cspolicy2standard(cspolicy):
    resp = {}
    standard_policy = {}
    standard_policy['format'] = 'cloudstack'
    resp['results'] = cs_parser.cspolicy2standard(cspolicy)
    standard_policy['standard_policy']=resp
    return standard_policy


# # NMLC检测
# def nmlcTest(nmlc):
#     resp = {}
#     standard_policy = {}
#     resp['rules'] = NMLCTest.main(nmlc)
#     return standard_policy
