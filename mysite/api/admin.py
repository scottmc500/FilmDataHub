from django.contrib import admin
from .models import Actor, Director, Film, Producer, Writer

# Register your models here.
for cls in [Actor, Director, Film, Producer, Writer]:
    admin.site.register(cls)