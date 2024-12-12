"""app URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.conf.urls import include, url
from adaptor import views, models
from django.views.generic import TemplateView
from django.views.static import serve
from django.conf import settings
from django.urls import path, include
from rest_framework import serializers, viewsets,routers

class RolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Role
        fields = ('id', 'uuid', 'name', 'role_type', 'removed', 'description', 'is_default')

class RolePermissionsSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.RolePermissions
        fields = ('id', 'uuid', 'role', 'role_name', 'rule', 'permission', 'description', 'sort_order')

class OsPolicySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.OsPolicy
        fields = "__all__"


class RolesViewSet(viewsets.ModelViewSet):
    queryset = models.Role.objects.all()
    serializer_class = RolesSerializer


class RolePermissionsViewSet(viewsets.ModelViewSet):
    queryset = models.RolePermissions.objects.all()
    serializer_class = RolePermissionsSerializer

class OsPolicyViewSet(viewsets.ModelViewSet):
    queryset = models.OsPolicy.objects.all()
    serializer_class = OsPolicySerializer


router = routers.DefaultRouter()
router.register(r'role', views.RolesViewSet)
router.register(r'rolepermissions', views.RolePermissionsViewSet)
router.register(r'Policy', views.OsPolicyViewSet)
router.register(r'ALYPolicy', views.ALYPolicyViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^', include(router.urls)),
    # openstack
    url(r'^ospolicy/$', views.PolicyView.as_view(), name='policy_get_post'),
    url(r'^ospolicy/(?P<id>\d+)/$', views.EditPolicyView.as_view()),
    url(r'^ospolicy2standard/', views.AdaptorStandardView.as_view(), name='my_rest_view'),
    url(r'^standard2ospolicy/', views.AdaptorOSView.as_view(), name='my_rest_view'),
    # cloudstack
    url(r'^docs/(?P<path>.*)$', serve, {"document_root": settings.MEDIA_ROOT}),
    url(r'^cspolicy/$', views.CSPolicyView.as_view(), name='cspolicy_get_post'),
    url(r'^cspolicy/(?P<id>\d+)/$', views.EditCSView.as_view()),
    url(r'^cspolicy2standard/', views.AdaptorStandardCSView.as_view(), name='my_rest_view'),
    #aliyun
    url(r'^alypolicy/$', views.ALYPolicyView.as_view(), name='policy_get_post'),
    url(r'^alypolicy/(?P<id>\d+)/$', views.EditALYView.as_view()),
    url(r'^aliyun2standard/', views.AdaptorStandardALView.as_view(), name='my_rest_view'),
    url(r'^standard2aliyun/', views.AdaptorALView.as_view(), name='my_rest_view'),

    # url(r'^antlr/', views.AntlrView.as_view(), name='my_rest_view'),
]
