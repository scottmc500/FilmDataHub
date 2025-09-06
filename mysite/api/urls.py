from django.urls import path
from . import views

urlpatterns = [
    path("films", views.FilmListCreate.as_view(), name="film-view-create"),
    path("films/<int:pk>", views.FilmRetrieveUpdateDestroy.as_view(), name="film-retrieve-update-destroy"),
    path("actors", views.ActorListCreate.as_view(), name="actor-view-create"),
    path("actors/<int:pk>", views.ActorRetrieveUpdateDestroy.as_view(), name="actor-retrieve-update-destroy"),
    path("directors", views.DirectorListCreate.as_view(), name="director-view-create"),
    path("directors/<int:pk>", views.DirectorRetrieveUpdateDestroy.as_view(), name="director-retrieve-update-destroy")
]