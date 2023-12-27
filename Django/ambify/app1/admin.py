from django.contrib import admin
from .models import Element,Soundscape

@admin.register(Element)
class Elementadmin(admin.ModelAdmin):
    list_display= ['id','name']

@admin.register(Soundscape) 
class Soundscapeadmin(admin.ModelAdmin):
    list_display=['id','name']
#
#    def show_element():
#        return ", ".join([_element.name for _element in obj.Element.all()])        
## Register your models here.
