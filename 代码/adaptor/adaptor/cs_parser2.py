from pyeda.inter import *
import json
import re
import copy

def parse_rules(cspolicy, rules):
    # 创建一个新字典
    rules = {"effect": None,  "roles": None, "resource": None, "resource_type": None, "service": None,
             "action": None, "allias": None, "conditon": None}
    for attr, value in cspolicy.items():
        print((attr,value))
        if ('permission' in attr):
            entry = {'effect': value}  # 创建新条件条目
            rules.update(entry)
        if ('rule' in attr):
            if(value=="*"):
                entry = {'resource_type': "*","resource":"*"}  # 创建新条件条目
                rules.update(entry)
            else:
                vl1 = re.findall('[A-Z][^A-Z]*', value)[0]
                vl2 = value.split(vl1)[0]
                vl3 = value.split(vl2)[1]
                entry = {'service': "", 'action': vl2, 'resource_type': vl3}  # 创建新条件条目
                rules.update(entry)
        if ('role_name' in attr):
            entry = {'roles': value.lower()}  # 创建新条件条目
            rules.update(entry)

    print(rules)
    return rules

# cloudstack转成标准语言
def cspolicy2standard(cspolicy):

    standard_policy = []
    rules={}
    print(cspolicy)
    for i in cspolicy:
      print(i)
      rules = parse_rules(i, rules)
      standard_policy.append(rules)
    #python manage.py runserver
    return standard_policy


# 标准语言转成cloudstack
def standard2ospolicy(standard_policy):
    rules = {}
    attr=""
    value=""
    alias=""

    return rules
