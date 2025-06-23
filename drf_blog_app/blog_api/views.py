from django.shortcuts import render
from rest_framework import viewsets
from .serializers import RegisterSerializer, PostSerializer, PostDetailSerializer
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from .models import Post
from django.contrib.auth.models import User
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer

class PostListView(generics.ListAPIView):
    queryset=Post.objects.all()
    serializer_class = PostSerializer
class PostDetailView(generics.RetrieveAPIView):
    queryset=Post.objects.all()
    serializer_class = PostDetailSerializer

class PostCreateView(generics.CreateAPIView):
    queryset=Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [TokenAuthentication]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)   
# Create your views here.
