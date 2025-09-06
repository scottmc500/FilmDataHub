from django.shortcuts import render
from rest_framework import generics, status
from rest_framework.response import Response
from .models import Film, Actor, Director
from .serializers import FilmSerializer, ActorSerializer, DirectorSerializer

# Create your views here.
class FilmListCreate(generics.ListCreateAPIView):
    queryset = Film.objects.all()
    serializer_class = FilmSerializer

    def delete(self, request, *args, **kwargs):
        Film.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class FilmRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Film.objects.all()
    serializer_class = FilmSerializer
    lookup_field = "pk"

class ActorListCreate(generics.ListCreateAPIView):
    queryset = Actor.objects.all()
    serializer_class = ActorSerializer

    def delete(self, request, *args, **kwargs):
        Actor.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class ActorRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Actor.objects.all()
    serializer_class = ActorSerializer
    lookup_field = "pk"

class DirectorListCreate(generics.ListCreateAPIView):
    queryset = Director.objects.all()
    serializer_class = DirectorSerializer

    def delete(self, request, *args, **kwargs):
        Director.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class DirectorRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Director.objects.all()
    serializer_class = DirectorSerializer
    lookup_field = "pk"