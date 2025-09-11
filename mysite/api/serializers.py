from rest_framework.serializers import ModelSerializer
from .models import Film, Actor, Director, Producer, Writer

class FilmSerializer(ModelSerializer):
    class Meta:
            model = Film
            fields = ["id", "title", "description", "release_date", "length", "director", "writer", "actor", "producer"]

class ActorSerializer(ModelSerializer):
    class Meta:
        model = Actor
        fields = ["id", "name", "gender", "birth_date"]

class DirectorSerializer(ModelSerializer):
    class Meta:
        model = Director
        fields = ["id", "name", "gender", "birth_date"]

class ProducerSerializer(ModelSerializer):
    class Meta:
        model = Producer
        fields = ["id", "name", "gender", "birth_date"]

class WriterSerializer(ModelSerializer):
    class Meta:
        model = Writer
        fields = ["id", "name", "gender", "birth_date"]