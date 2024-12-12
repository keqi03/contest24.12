# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

class Role(models.Model):
    uuid = models.CharField(unique=True, max_length=255, blank=True, null=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    role_type = models.CharField(max_length=255)
    removed = models.DateTimeField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    is_default = models.IntegerField()
    class Meta:
        managed = True
        db_table = 'roles'
        verbose_name = 'Roles'
        verbose_name_plural = verbose_name
        ordering = ['id']
    def __str__(self):
        # Django管理站点加载一个对象时显示名称
        # 建议返回一个友好的，用户可读的字符串作为对象的str
        return "%s" % (self.name)

class RolePermissions(models.Model):
    uuid = models.CharField(unique=True, max_length=255, blank=True, null=True)
    role = models.ForeignKey(Role, models.DO_NOTHING, related_name='RolePermissions')
    rule = models.CharField(max_length=255)
    permission = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    sort_order = models.PositiveBigIntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'role_permissions'
        verbose_name = 'Role_permissions'
        verbose_name_plural = verbose_name
        ordering = ['id']
    def __str__(self):
        # Django管理站点加载一个对象时显示名称
        # 建议返回一个友好的，用户可读的字符串作为对象的str
        return "%s,%s,%s" % (self.role,self.rule,self.permission)

class OsPolicy(models.Model):
    policy_id = models.CharField(max_length=20)
    policy_name = models.CharField(max_length=36)
    version = models.CharField(max_length=20)
    format = models.CharField(max_length=20)
    policy_rules_addr = models.CharField(max_length=50)
    isselected=models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'os_policy'
        verbose_name = 'OsPolicy'
        verbose_name_plural = verbose_name

class ALYPolicy(models.Model):
    policy_id = models.CharField(max_length=20)
    policy_name = models.CharField(max_length=36)
    version = models.CharField(max_length=20)
    format = models.CharField(max_length=20)
    policy_rules_addr = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'aly_policy'
        verbose_name = 'ALYPolicy'
        verbose_name_plural = verbose_name
