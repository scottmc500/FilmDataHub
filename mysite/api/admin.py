from django.contrib import admin
from .models import Actor, Director, Film, Producer

# Register your models here.
for cls in [Actor, Director, Film, Producer]:
    admin.site.register(cls)