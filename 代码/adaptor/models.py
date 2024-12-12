# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Account(models.Model):
    id = models.BigAutoField(primary_key=True)
    account_name = models.CharField(max_length=100, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=40, blank=True, null=True)
    type = models.PositiveIntegerField()
    role = models.ForeignKey('Roles', models.DO_NOTHING, blank=True, null=True)
    domain = models.ForeignKey('Domain', models.DO_NOTHING, blank=True, null=True)
    state = models.CharField(max_length=10)
    removed = models.DateTimeField(blank=True, null=True)
    cleanup_needed = models.IntegerField()
    network_domain = models.CharField(max_length=255, blank=True, null=True)
    default_zone = models.ForeignKey('DataCenter', models.DO_NOTHING, blank=True, null=True)
    default = models.PositiveIntegerField()

    class Meta:
        managed = False
        db_table = 'account'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class OsPolicy(models.Model):
    policy_id = models.CharField(max_length=20)
    policy_name = models.CharField(max_length=36)
    version = models.CharField(max_length=20)
    format = models.CharField(max_length=20)
    id = models.IntegerField(primary_key=True)
    policy_rules_addr = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'os_policy'


class OsPolicyRules(models.Model):
    policy_id = models.CharField(max_length=20)
    version = models.CharField(max_length=20)
    policy_name = models.CharField(max_length=36)
    format = models.CharField(max_length=20)
    id = models.IntegerField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'os_policy_rules'


class RolePermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    uuid = models.CharField(unique=True, max_length=255, blank=True, null=True)
    role = models.ForeignKey('Roles', models.DO_NOTHING)
    rule = models.CharField(max_length=255)
    permission = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    sort_order = models.PositiveBigIntegerField()

    class Meta:
        managed = False
        db_table = 'role_permissions'
        unique_together = (('role', 'rule'),)


class Roles(models.Model):
    id = models.BigAutoField(primary_key=True)
    uuid = models.CharField(unique=True, max_length=255, blank=True, null=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    role_type = models.CharField(max_length=255)
    removed = models.DateTimeField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    is_default = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'roles'
        unique_together = (('name', 'role_type'),)


class User(models.Model):
    id = models.BigAutoField(primary_key=True)
    uuid = models.CharField(unique=True, max_length=40, blank=True, null=True)
    username = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    account = models.ForeignKey(Account, models.DO_NOTHING)
    firstname = models.CharField(max_length=255, blank=True, null=True)
    lastname = models.CharField(max_length=255, blank=True, null=True)
    email = models.CharField(max_length=255, blank=True, null=True)
    state = models.CharField(max_length=10)
    api_key = models.CharField(unique=True, max_length=255, blank=True, null=True)
    secret_key = models.CharField(max_length=255, blank=True, null=True)
    created = models.DateTimeField()
    removed = models.DateTimeField(blank=True, null=True)
    timezone = models.CharField(max_length=30, blank=True, null=True)
    registration_token = models.CharField(max_length=255, blank=True, null=True)
    is_registered = models.IntegerField()
    incorrect_login_attempts = models.PositiveIntegerField()
    default = models.PositiveIntegerField()
    source = models.CharField(max_length=40)
    external_entity = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user'
