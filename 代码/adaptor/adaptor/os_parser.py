from pyeda.inter import *
import json
import re
import copy
import time

# 从策略JSON对象中解析alias最终的rule
def parse_ospolicy(attr, value, ospolicy, alias, target):
    # target层  target："service:API"
    if (':' in attr) and (attr not in target):  # 如果attr中有':'，那么是target
        target[attr] = value
    else:  #别名层替换规则，即所有别名最终拥有的规则 alias：definition
        alias[attr]=value
        values = re.split(" and | or ", value) # 使用“and”或“or”分割值
        for i in values:                       # 值中所有“规则”的循环
            i = i.strip('(').strip(')')        # 删除规则中的括号
            i = i.replace(' ', '')             # 删除规则中的所有空格
            if i[:5] == 'rule:':               # 如果规则为alias，引用其他规则...
                newi = ospolicy[i[5:]]           # 将“规则”替换为其引用
                alias[attr] = alias[attr].replace(i, newi)  # 替换规则数组中的规则
    return  alias,target

def parse(ospolicy):
    # 分别名层、API层
    alias = {}
    target = {}
    # 阅读策略并解析别名层、提取API层
    for attr, value in ospolicy.items():
        alias,target = parse_ospolicy(attr, value, ospolicy, alias, target)
    return alias, target


def parse_rules(attr, value, ospolicy, alias, rules,ruleId):
    # 2.1创建一个新字典
    # rules = {"effect": None, "roles": None, "resource": None, "resource_type": None, "service": None,
    #          "action": None, "alias": None, "conditon": None}
    effect=""
    roles=""
    condition=""
    service=""
    action=""
    resource_type=""
    resource=""
    alias1 = ""

    # 2.2 对target赋值："service:API"= service：action_resource_type
    at, vl = attr.split(':')  # Split the "rule" in "attribute":"value"
    if('_'in vl):
        vl1,vl2=vl.split('_',1)
        service=at
        action=vl1
        resource_type=vl2  # 创建新条件条目
    else:
        service=at
        action=vl
    # 全部允许
    if(value=="" or value==[] or value=="@"):
        effect= 'allow'
        roles = '*'
        condition = '*'
    # 全部拒绝
    if(value=="!"):
        effect= 'deny'
        roles = '*'
        condition = '*'
    # rule为role，指定角色
    if("role:"in value):
        # rule为not role，限制某个角色不可以执行。
        if("not" in value):
            vl1, vl2 = value.split(':')
            effect = 'deny'
            roles = vl2
            condition = '*'
        else:
            vl1, vl2 = value.split(':')
            effect = 'allow'
            roles = vl2
    # rule为比较%。
    if("%" in value):
      effect = 'allow'
      condition = value
      roles = '*'
    # rule为引用别名alias中的规则。
    if("rule:"in value):
        alias1=value
        # 查找用几个规则
        if (value.find(" or ") != -1):
          vl1 = value.split(' or ')
          for i in vl1:
            if ("rule:"in i):
              vl2, vl3 = i.split(':')
              roles = alias[vl3]
            else:
              roles = roles+" or "+i
              condition="*"
              alias1=""
              effect = 'allow'
        elif (value.find(" and ") != -1):
          vl1 = value.split(' and ')
          for i in vl1:
            if ("rule:"in i):
              vl2, vl3 = i.split(':')
              roles = alias[vl3]
            if ("%" in i):
              roles = roles
              condition=i
              alias1=""
              effect = 'allow'
        else:
          # 单个
          vl1, vl2 = value.split(':')
          roles = alias[vl2]
          if ("%" in roles ):
            if("or" not in roles):
              if ("and" not in roles):#单属性判断
                condition=roles
                roles="*"
                effect = 'allow'
              else: #且属性判断
                n1=roles.index(":%")
                if(roles[:n1].find("and")!=-1):
                  if (roles[n1:].find("and") != -1):
                    n2 = roles[:n1].index("and")
                    n3 = roles[n1:].index("and")
                    effect = 'allow'
                    condition = roles[n2 + 4:n1] + roles[n1:n1 + n3 - 1]
                    roles = roles[:n2 + 4] + roles[n1 + n3 + 4:]
                  else:
                    n2 = roles[:n1].index("and")
                    effect = 'allow'
                    condition = roles[n2 + 4:]
                    roles = roles[:n2 + 4]
                else:
                  n2 = roles[n1:].index("and")
                  effect = 'allow'
                  condition = roles[:n1 + n2 - 1]
                  roles = roles[n1 + n2 + 4:]
            else:
              effect = 'allow'
          else:
            effect = 'allow'
            condition = '*'
    if("is_admin:True"in value):
      effect = 'allow'
      condition = '*'
      roles=value
    rules = '%s:(%s,%s,%s)=>(%s,%s,%s,%s,%s);' % (ruleId, effect, roles, condition, service, action, resource_type, resource, alias1)
    return rules

# openstack转成标准语言
def ospolicy2standard(ospolicy):
    start_time = time.time()
    print("start_time:", start_time)
    standard_policy = []
    rules={}
    #1.分析os策略内容,进行解析与分层
    alias, target= parse(ospolicy)
    # 2.对target层进行转换
    ruleID=0
    for attr, value in target.items():
        ruleID=ruleID+1
        rules=parse_rules(attr, value, ospolicy, alias, rules,ruleID)
        standard_policy.append(rules)
    #python manage.py runserver
    end_time = time.time()
    print("end_time:", end_time)
    print("time cost:", float(end_time - start_time) * 1000.0, "ms")
    return standard_policy

def parse_strules(st, standard_policy, rules):
    # 2.1创建一个新字典
    flag1, flag2, flag3 = 3, 3, 3
    entry,entry1,entry2,entry3,entry4,entry5,rule,alias,rule2="","","","","","","","",""
    for attr, value in st.items():
        if (attr == "service"):
            entry1 = value
        if (attr == "action"):
            entry2 = ":" + value
        if (attr == "resource_type"):
            if(value):
                entry3 =  "_" + value
        if (attr == "effect"):
            if(value=="deny"):
                flag1=0
            if(value=="allow"):
                flag1=1
        if (attr == "roles"):
            # 非空
            if(value):
                if("%" in value):
                    flag2=2
                    entry4 = value
                else:
                    flag2 = 1
                    entry4 = value
            else:
                flag2=0
        if (attr == "alias"):
            # 非空
            if(value):
                flag3=1
                entry5 = value
                alias=value
            else:
                flag3=0
        # 禁止任何人
        if(flag1==0 and flag2==0 and flag3==0):
            rule="!"
        # 允许所有
        if(flag1==1 and flag2==0 and flag3==0):
            rule=""
        # 允许指定角色
        if(flag1==1 and flag2==1 and flag3==0):
            rule="role:"+entry4
        # 拒绝指定角色
        if(flag1==0 and flag2==1 and flag3==0):
            rule="not role:"+entry4
        # 别名
        if(flag1==1 and flag3==1):
            rule="rule:"+entry5
            # 返回别名的规则
            rule2=entry4
        # 比较
        if(flag1==1 and flag2==2 and flag3==0):
            rule=entry4
        entry=entry1+entry2+entry3
    return entry,rule,alias,rule2


# 标准语言转成openstack
def standard2ospolicy(standard_policy):
    rules = {}
    attr=""
    value=""
    alias=""
    # 1分析标准语言策略内容,进行target转换规则，alias转换
    for st in standard_policy['rules']:
        attr,value,alias,rule2= parse_strules(st, standard_policy, rules)
        if(alias):
            rules[alias]=rule2
    # 2进行target转换规则
    for st in standard_policy['rules']:
        attr,value,alias,rule2= parse_strules(st, standard_policy, rules)
        rules[attr]=value
    for attr, value in rules.items():
        for attr2, value2 in rules.items():
            if(attr!=attr2 and ":" not in attr and ":" not in attr2):
                if(value in value2):
                    value2=value2.replace(value,"rule:"+attr)
                    rules[attr2] = value2
    return rules
