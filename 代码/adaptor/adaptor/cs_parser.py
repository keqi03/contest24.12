from pyeda.inter import *
import json
import re
import copy

def parse_rules(cspolicy, rules, ruleId):
    # 创建一个新字典
    # rules = {"effect": None,  "roles": None, "resource": None, "resource_type": None, "service": None,
    #          "action": None, "allias": None, "conditon": None}
    effect=""
    roles=""
    condition=""
    service=""
    action=""
    resource_type=""
    resource=""
    alias1 = ""
    for attr, value in cspolicy.items():
        print((attr,value))
        if ('permission' in attr):
            effect = value.lower()
        if ('rule' in attr):
            if(value=="*"):
                resource_type="*"
                resource = "*"
            else:
                vl1 = re.findall('[A-Z][^A-Z]*', value)[0]
                vl2 = value.split(vl1)[0]
                vl3 = value.split(vl2)[1]
                action=vl2
                resource_type=vl3
        if ('role_name' in attr):
            roles=value.lower()
    rules = '%s:(%s,%s,%s)=>(%s,%s,%s,%s,%s);' % (ruleId, effect, roles, condition, service, action, resource_type, resource, alias1)
    print(rules)
    return rules

# cloudstack转成标准语言
def cspolicy2standard(cspolicy):

    standard_policy = []
    rules={}
    print(cspolicy)
    ruleID=0
    for i in cspolicy:
      ruleID = ruleID + 1
      rules = parse_rules(i, rules, ruleID)
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
