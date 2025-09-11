from django.db import models
from django.utils.translation import gettext_lazy as lazy

class Person(models.Model):
    class Gender(models.TextChoices):
        MALE = 'M', lazy('Male')
        FEMALE = 'F', lazy('Female')
        OTHER = 'O', lazy('Other')
    
    name = models.CharField(max_length=100)
    gender = models.CharField(max_length=1, choices=Gender.choices, default=Gender.MALE)
    birth_date = models.DateField()
    class Meta:
        abstract = True

class Director(Person):
    def __str__(self):
        return self.name

class Writer(Person):
    def __str__(self):
        return self.name

class Producer(Person):
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
    length = models.IntegerField()
    director = models.ForeignKey(Director, on_delete=models.CASCADE)
    writer = models.ForeignKey(Writer, on_delete=models.CASCADE)
    actor = models.ManyToManyField(Actor)
    producer = models.ManyToManyField(Producer)

    def __str__(self):
        return self.title
