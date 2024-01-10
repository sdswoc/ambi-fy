from django.contrib import admin
from .models import Element,Soundscape, History

@admin.register(Element)
class Elementadmin(admin.ModelAdmin):
    list_display= ['id','name']

@admin.register(Soundscape)
class Soundscapeadmin(admin.ModelAdmin):
    list_display=['id','name']
@admin.register(History)
class Historyadmin(admin.ModelAdmin):
    list_display= ['id', 'datetime']