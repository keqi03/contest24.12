from rest_framework import serializers
from adaptor import models

class RolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Role
        fields = "__all__"



class RolePermissionsSerializer(serializers.ModelSerializer):
    # 获取外键对应的名字
    role = serializers.PrimaryKeyRelatedField(label="role_id",queryset=models.Role.objects.all(), )
    role_name = serializers.SerializerMethodField()

    def get_role_name(self, obj):
        print("xxxx", obj)
        return obj.role.name

    class Meta:
        model = models.RolePermissions
        fields = ('id', 'uuid', 'role','role_name', 'rule', 'permission', 'description', 'sort_order')

class OsPolicySerializer(serializers.ModelSerializer):
    # 定义模型中需要序列化的字段,匹配的上的进行序列化，匹配不上的丢弃
    id = serializers.IntegerField(required=False)  # 反序列化不匹配该字段
    policy_id = serializers.CharField(max_length=32)
    policy_name = serializers.CharField(max_length=36)
    version = serializers.CharField(max_length=20)
    format = serializers.CharField(max_length=20)
    policy_rules_addr = serializers.CharField(max_length=50)

    class Meta:
        model = models.OsPolicy
        fields = "__all__"

class ALYPolicySerializer(serializers.ModelSerializer):
    # 定义模型中需要序列化的字段,匹配的上的进行序列化，匹配不上的丢弃
    id = serializers.IntegerField(required=False)  # 反序列化不匹配该字段
    policy_id = serializers.CharField(max_length=32)
    policy_name = serializers.CharField(max_length=36)
    version = serializers.CharField(max_length=20)
    format = serializers.CharField(max_length=20)
    policy_rules_addr = serializers.CharField(max_length=50)

    class Meta:
        model = models.ALYPolicy
        fields = "__all__"

