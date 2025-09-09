from rest_framework.serializers import ModelSerializer
from .models import Film, Actor, Director

class FilmSerializer(ModelSerializer):
    class Meta:
            model = Film
            fields = ["id", "title", "description", "release_date", "director", "length", "actor"]

class ActorSerializer(ModelSerializer):
    class Meta:
        model = Actor
        fields = ["id", "name", "birth_date"]

class DirectorSerializer(ModelSerializer):
    class Meta:
        model = Director
        fields = ["id", "name", "birth_date"]