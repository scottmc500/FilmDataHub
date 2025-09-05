from django.db import models

# Create your models here.
class Film(models.Model):
    title = models.CharField(max_length=200)
    release_date = models.DateField()
    director = models.CharField(max_length=200)
    length = models.IntegerField()