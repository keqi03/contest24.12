from pyeda.inter import *
import json
import re
import copy


def parse_rules(attr, value, aliyunpolicy, rules,ruleId):
    # 创建一个新字典
    # rules = {"effect": None, "roles": None, "resource": None, "resource_type": None, "service": None,
    #           "action": None, "allias": None, "conditon": None}
    effect=""
    roles=""
    condition=""
    service=""
    action=""
    resource_type=""
    resource=""
    alias1 = ""
    at, vl = value.split(':')  # Split the "rule" in "attribute":"value"
    if ('*' in vl):
        vl1 =re.findall('[A-Z][^A-Z]*', vl)
        print(len(vl1))
        if(len(vl1)>1):
            vl1=vl1[0]
            service=at
            action=vl1
            resource_type=vl.split(vl1)[1]
        else:
            vl = vl.split('*')[0]
            if (vl == ''):
                vl = '*'
            service=at
            action=vl1
            resource_type='*'
    else:
        vl1 =re.findall('[A-Z][^A-Z]*', vl)[0]
        vl2=vl.split(vl1)[1]
        service = at
        action = vl1
        resource_type = vl2
    if(aliyunpolicy['Effect']=='Allow'):
        effect='allow'
    if(aliyunpolicy['Effect']=='Deny'):
        effect='deny'
    resource= aliyunpolicy['Resource']
    if('Condition' in aliyunpolicy):
        condition=aliyunpolicy['Condition']
    rules = '%s:(%s,%s,%s)=>(%s,%s,%s,%s,%s);' % (
    ruleId, effect, roles, condition, service, action, resource_type, resource, alias1)
    return rules

# 阿里云转成标准语言
def aliyun2standard(aliyunpolicy):

    standard_policy = []
    rules={}
    for st in aliyunpolicy:
        for attr, value in st.items():
            if (attr == "Action"):
                ruleID = 0
                if (isinstance(value, list)):
                    for sa in value:
                        ruleID = ruleID + 1
                        rules = parse_rules(attr, sa, st, rules,ruleID)
                        standard_policy.append(rules)
                else:
                    ruleID = ruleID + 1
                    rules = parse_rules(attr, value, st, rules,ruleID)
                    standard_policy.append(rules)
    #python manage.py runserver
    return standard_policy

def parse_alrules(st, aliyunpolicy, rules):
    # 创建一个新字典
    rules = {"Effect": None, "Action": None, "Resource": None}
    entry,entry1,entry2,entry3="","","",""
    for attr, value in st.items():
        if (attr == "effect"):
            if(value=="allow"):
                entry = {'Effect': "Allow"}  # 创建新条件条目
                rules.update(entry)
            if(value=="deny"):
                entry = {'Effect': "Deny"}  # 创建新条件条目
                rules.update(entry)
        if (attr == "service"):
            entry1 = value
        if (attr == "action"):
            entry2 = ":" + value
        if (attr == "resource_type"):
            if(value):
                entry3 =value
        entry=entry1+entry2+entry3
        if("**" in entry):
            entry=entry.replace('**','*')
        entry = {'Action': entry}  # 创建新条件条目
        rules.update(entry)
        if (attr == "resource"):
            entry = {'Resource': value}  # 创建新条件条目
            rules.update(entry)
        if (attr == "condition"):
            entry = {'Condition': value}  # 创建新条件条目
            rules.update(entry)
    return rules

# 标准语言转成阿里云
def standard2aliyun(standard_policy):
    aliyun_policy=[]
    rules={}
    for st in standard_policy['rules']:
        rules= parse_alrules(st, standard_policy, rules)
        aliyun_policy.append(rules)
    return aliyun_policy
