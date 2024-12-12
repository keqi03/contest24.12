from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from adaptor import adaptor
from rest_framework.viewsets import ModelViewSet
from adaptor import models, serializers
from rest_framework import viewsets,filters
from adaptor.serializers import RolesSerializer, RolePermissionsSerializer,OsPolicySerializer,ALYPolicySerializer
# from adaptor.filter import RoleFilter,RolePermissionsFilter
# from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.pagination import PageNumberPagination
import json

class StandardPageNumberPagination(PageNumberPagination):
    page_size_query_param = 'page_size'
    max_page_size = 10

class RolesViewSet(viewsets.ModelViewSet):
    queryset = models.Role.objects.all()
    serializer_class = RolesSerializer


class RolePermissionsViewSet(viewsets.ModelViewSet):
    queryset = models.RolePermissions.objects.all()
    serializer_class = RolePermissionsSerializer
    # 配置搜索功能
    filter_backends = (filters.SearchFilter, filters.OrderingFilter)
    # 搜索
    search_fields = ('uuid','rule','permission')


class OsPolicyViewSet(viewsets.ModelViewSet):
    queryset = models.OsPolicy.objects.all().order_by('pk')
    serializer_class = OsPolicySerializer
    pagination_class = StandardPageNumberPagination
    # 配置搜索功能
    filter_backends = (filters.SearchFilter, filters.OrderingFilter)
    # 搜索
    search_fields = ('policy_id', 'policy_name','version','format')

class ALYPolicyViewSet(viewsets.ModelViewSet):
    queryset = models.ALYPolicy.objects.all().order_by('pk')
    serializer_class = ALYPolicySerializer
    pagination_class = StandardPageNumberPagination
    # 配置搜索功能
    filter_backends = (filters.SearchFilter, filters.OrderingFilter)
    # 搜索
    search_fields = ('policy_id', 'policy_name','version','format')

# Create your views here.
class AdaptorStandardView(APIView):
    def post(self, request, *args, **kwargs):
        resp = {}
        if (not "format" in request.data or not "policy" in request.data):
            resp['detail'] = "Missing argument"
            return Response(resp, status=412)
        elif (request.data["format"] == "openstack"):
            resp = adaptor.ospolicy2standard(request.data["policy"])
            return Response(resp)
        else:
            resp['detail'] = "Policy Format not Supported."
            return Response(resp, status=415)
    # def post(self, request, *args, **kwargs):
    #     resp = {}
    #     s=request.data["params"]
    #     t = json.loads(s)
    #     if (not "format" in s or not "policy" in s):
    #         resp['detail'] = "Missing argument"
    #         return Response(resp, status=412)
    #     elif (t["format"] == "openstack"):
    #         resp = adaptor.ospolicy2standard(t["policy"])
    #         return Response(resp)
    #     else:
    #         resp['detail'] = "Policy Format not Supported."
    #         return Response(resp, status=415)

class AdaptorOSView(APIView):
    def post(self, request, *args, **kwargs):
        resp = {}
        print(request.data)
        s = request.data["params"]
        t = json.loads(s)
        if (not "format" in s or not "standard_policy" in s):
            resp['detail'] = "Missing argument"
            return Response(resp, status=412)
        elif (t["format"] == "openstack"):
            resp = adaptor.standard2ospolicy(t["standard_policy"])
            return Response(resp)
        else:
            resp['detail'] = "Policy Format not Supported."
            return Response(resp, status=415)
class AdaptorStandardALView(APIView):
    def post(self, request, *args, **kwargs):
        resp = {}
        t =request.data
        # s=request.data["params"]
        # t = json.loads(s)
        # print(s)
        if (not "Statement" in t or not "Version" in t):
            resp['detail'] = "Missing argument"
            return Response(resp, status=412)
        elif (t["Version"] == "1"):
            resp = adaptor.aliyun2standard(t["Statement"])
            return Response(resp)
        else:
            resp['detail'] = "Policy Format not Supported."
            return Response(resp, status=415)

class AdaptorALView(APIView):
    def post(self, request, *args, **kwargs):
        resp = {}
        if (not "format" in request.data or not "standard_policy" in request.data):
            resp['detail'] = "Missing argument"
            return Response(resp, status=412)
        elif (request.data["format"] == "aliyun"):
            resp = adaptor.standard2aliyun(request.data["standard_policy"])
            return Response(resp)
        else:
            resp['detail'] = "Policy Format not Supported."
            return Response(resp, status=415)


class AdaptorStandardCSView(APIView):
    def post(self, request, *args, **kwargs):
        resp = {}
        s=request.data['results']
        resp = adaptor.cspolicy2standard(s)
        return Response(resp)
#

# class AntlrView(APIView):
#   def post(self, request, *args, **kwargs):
#     resp = {}
#     s=request.data["standard_policy"]["rules"]
#     resp = adaptor.nmlcTest(s)
#     return Response(resp)

class PolicyView(APIView):
    def get_object(self, pk):
        try:
            return models.OsPolicy.objects.get(policy_id=pk)
        except OsPolicySerializer.DoesNotExist:
            return Response(status=404)
    def get(self, request, pk=None):
        print(pk)
        if pk:
            merchant = self.get_object(pk)
            serializer = OsPolicySerializer(merchant)
            return Response(serializer.data)
        else:
            queryset = models.OsPolicy.objects.all()
            serializer = OsPolicySerializer(instance=queryset, many=True)
            return Response(serializer.data)
    def post(self, request, *args, **kwargs):
        """新增数据 返回新建的书籍的数据 json格式 """
        # 用序列化器进行校验！！！
        # 注意：这里用的是request.data去取新增的值！！！
        print('>>>>>>',request.data)
        ser_book = OsPolicySerializer(data=request.data["params"])
        print(ser_book)
        if ser_book.is_valid():
            ser_book.save()
            # 校验成功并且成功保存的话~返回新增的数据！
            return Response(status=200)
        else:
            print(ser_book.errors)
            return Response(ser_book.errors)

class CSPolicyView(APIView):
    def get_object(self, pk):
        try:
            return models.RolePermissions.objects.get(policy_id=pk)
        except RolePermissionsSerializer.DoesNotExist:
            return Response(status=404)
    def get(self, request, pk=None):
        print(pk)
        if pk:
            merchant = self.get_object(pk)
            serializer = RolePermissionsSerializer(merchant)
            return Response(serializer.data)
        else:
            queryset = models.OsPolicy.objects.all()
            serializer = RolePermissionsSerializer(instance=queryset, many=True)
            return Response(serializer.data)
    def post(self, request, *args, **kwargs):
        """新增数据 返回新建的书籍的数据 json格式 """
        # 用序列化器进行校验！！！
        # 注意：这里用的是request.data去取新增的值！！！
        print('>>>>>>',request.data)
        ser_book = RolePermissionsSerializer(data=request.data["params"])
        print(ser_book)
        if ser_book.is_valid():
            ser_book.save()
            # 校验成功并且成功保存的话~返回新增的数据！
            return Response(status=200)
        else:
            print(ser_book.errors)
            return Response(ser_book.errors)

class ALYPolicyView(APIView):
    def get_object(self, pk):
        try:
            return models.ALYPolicy.objects.get(policy_id=pk)
        except ALYPolicySerializer.DoesNotExist:
            return Response(status=404)
    def get(self, request, pk=None):
        print(pk)
        if pk:
            merchant = self.get_object(pk)
            serializer = ALYPolicySerializer(merchant)
            return Response(serializer.data)
        else:
            queryset = models.ALYPolicy.objects.all()
            serializer = ALYPolicySerializer(instance=queryset, many=True)
            return Response(serializer.data)
    def post(self, request, *args, **kwargs):
        """新增数据 返回新建的书籍的数据 json格式 """
        # 用序列化器进行校验！！！
        # 注意：这里用的是request.data去取新增的值！！！
        print('>>>>>>',request.data)
        ser_book = ALYPolicySerializer(data=request.data["params"])
        print(ser_book)
        if ser_book.is_valid():
            ser_book.save()
            # 校验成功并且成功保存的话~返回新增的数据！
            return Response(status=200)
        else:
            print(ser_book.errors)
            return Response(ser_book.errors)

# 带id的查询、更新、删除
class EditPolicyView(APIView):
    # 根据id查看数据
    def get(self, request, id):
        # 根据ip找到模型对象
        book_obj = models.OsPolicy.objects.filter(pk=id).first()
        print(book_obj)
        # 对模型对象进行序列化，返回序列化对象
        ser_obj = OsPolicySerializer(book_obj)

        # 返回序列化对象的数据
        return Response(ser_obj.data)

    # 根据id更新数据
    def put(self, request, id):
        # 根据ip找到模型对象
        book_obj =  models.OsPolicy.objects.filter(pk=id).first()

        # 将获取的数据根据模型对象进行序列化，返回序列化对象
        ser_obj = OsPolicySerializer(instance=book_obj, data=request.data, partial=True)
        # partial=True 部分匹配
        # data=request.data 前端提交的数据
        # instance=book_obj根据id找到的实例化对象

        # 对实例化对象进行校验
        if ser_obj.is_valid():
            # 校验通过,调用save进行更新
            ser_obj.save()  # 内部调用序列化器的update方法
            return Response(ser_obj.data)
        else:
            return Response(ser_obj.errors)  # 返回错误信息

    # 根据id删除数据
    def delete(self, request, id):
        # 根据ip找到模型对象
        book_obj =  models.OsPolicy.objects.filter(pk=id).first()

        if book_obj:
            book_obj.delete()
            return Response("删除成功")
        else:
            return Response("删除失败")

# 带id的查询、更新、删除
class EditCSView(APIView):
    # 根据id查看数据
    def get(self, request, id):
        book_obj = models.RolePermissions.objects.filter(pk=id).first()
        print(book_obj)
        ser_obj = RolePermissionsSerializer(book_obj)
        return Response(ser_obj.data)

    # 根据id更新数据
    def put(self, request, id):
        book_obj =  models.RolePermissions.objects.filter(pk=id).first()

        ser_obj = RolePermissionsSerializer(instance=book_obj, data=request.data, partial=True)
        if ser_obj.is_valid():
            # 校验通过,调用save进行更新
            ser_obj.save()  # 内部调用序列化器的update方法
            return Response(ser_obj.data)
        else:
            return Response(ser_obj.errors)  # 返回错误信息

    # 根据id删除数据
    def delete(self, request, id):
        book_obj =  models.RolePermissions.objects.filter(pk=id).first()
        if book_obj:
            book_obj.delete()
            return Response("删除成功")
        else:
            return Response("删除失败")

# 带id的查询、更新、删除
class EditALYView(APIView):
    # 根据id查看数据
    def get(self, request, id):
        book_obj = models.ALYPolicy.objects.filter(pk=id).first()
        print(book_obj)
        ser_obj = ALYPolicySerializer(book_obj)
        return Response(ser_obj.data)

    # 根据id更新数据
    def put(self, request, id):
        book_obj =  models.ALYPolicy.objects.filter(pk=id).first()

        ser_obj = ALYPolicySerializer(instance=book_obj, data=request.data, partial=True)
        if ser_obj.is_valid():
            # 校验通过,调用save进行更新
            ser_obj.save()  # 内部调用序列化器的update方法
            return Response(ser_obj.data)
        else:
            return Response(ser_obj.errors)  # 返回错误信息

    # 根据id删除数据
    def delete(self, request, id):
        book_obj =  models.ALYPolicy.objects.filter(pk=id).first()
        if book_obj:
            book_obj.delete()
            return Response("删除成功")
        else:
            return Response("删除失败")
