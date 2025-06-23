
from django.contrib.auth.models import User 
from rest_framework import serializers

from .models import Post

class RegisterSerializer(serializers.ModelSerializer):
    password=serializers.CharField(write_only=True, min_length=8, max_length=128)

    class Meta:
        model=User
        fields=('id', 'username', 'password')
    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password']
        )

        return user
class PostSerializer(serializers.ModelSerializer):

    author =serializers.StringRelatedField()

    class Meta:
        model=Post
        fields=('id', 'title', 'content', 'author', 'created_at', 'updated_at')
class PostDetailSerializer(serializers.ModelSerializer):
    summary = serializers.CharField(source='Summery', read_only=True)

    class Meta:
        model=Post
        fields = ['id', 'title', 'summary', 'created_at']


    