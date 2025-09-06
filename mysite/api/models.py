from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=100)
    birth_date = models.DateField()
    class Meta:
        abstract = True

class Director(Person):
    def __str__(self):
        return self.name

class Actor(Person):
    def __str__(self):
        return self.name

# Create your models here.
class Film(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    release_date = models.DateField()
    director = models.CharField(max_length=100)
    length = models.IntegerField()
    director = models.ForeignKey(Director, on_delete=models.CASCADE)
    actor = models.ManyToManyField(Actor)

    def __str__(self):
        return self.title
