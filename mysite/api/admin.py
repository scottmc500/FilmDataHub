from django.contrib import admin
from .models import Actor, Director, Film

# Register your models here.
for cls in [Actor, Director, Film]:
    admin.site.register(cls)