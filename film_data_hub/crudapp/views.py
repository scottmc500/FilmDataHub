from django.shortcuts import render, HttpResponse
from .models import Film

# Create your views here.
def home(request):
    return HttpResponse("Hello, world!")

def films(request):
    return Film.objects.all
