# 在模型所在app的admin.py中注册模型
from django.contrib import admin
# UserInfo：表名
# app_name：app的名称
from adaptor import models
from django.views.decorators.csrf import csrf_exempt
from django.middleware.csrf import get_token ,rotate_token
class RoleAdmin(admin.ModelAdmin):
    list_display = ('name', 'role_type')
    list_display_links = ('name', 'role_type')
    list_filter = ('name', 'role_type')
    list_per_page = 20
    search_fields = ['name', 'role_type']
admin.site.register(models.Role, RoleAdmin)

class RolePermissionsAdmin(admin.ModelAdmin):
    list_display = ('role', 'rule','permission')
    list_display_links = ('role', 'rule','permission')
    list_filter = ('role', 'rule','permission')
    list_per_page = 20
    search_fields = ['rule','permission']
    # raw_id_fields = ( 'role',)
    radio_fields = {"role": admin.VERTICAL}
    # radio_fields = {"permission": admin.VERTICAL}
    # list_editable = ('permission',)
admin.site.register(models.RolePermissions, RolePermissionsAdmin)
class OsPolicyAdmin(admin.ModelAdmin):
    list_display = ('policy_id', 'policy_name','version','format')
    list_display_links = ('policy_id', 'policy_name','version','format')
    list_filter = ('policy_id', 'policy_name','version','format')
    list_per_page = 20
    search_fields = ['policy_id', 'policy_name','version','format']

admin.site.register(models.OsPolicy, OsPolicyAdmin)

# 设置admin页面的header  
admin.site.site_header = '管理系统'  # 设置admin页面的title  
# admin.site.site_title = '用户信息'
class TopicAdmin(admin.ModelAdmin):  
    # 每页显示10条信息  
    list_per_page = 10