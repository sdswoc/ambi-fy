from django.db import models

# Create your models here.
class Element(models.Model):
     name = models.CharField(max_length=50, null= True, verbose_name = "Name")
     audio= models.FileField(upload_to='Audios/', max_length=100, null= True, verbose_name = "Audio")
     volume= models.IntegerField(default=50, verbose_name = "Volume", help_text = "Default volume is 50")
     class meta:
          verbose_name = "Element"
          verbose_name_plural = "Elements"
     def __str__(self):
          return self.name
     
class Soundscape(models.Model):
    name = models.CharField(max_length=100, null= True, verbose_name="Name")
    elements = models.ManyToManyField(Element)

    def __str__(self):
        return self.name
'''
     def __init__(self,name, audio, volume):
        self.name = name
        self.audio= audio
        self.volume= volume

class Generator(models.Model):
    element1=Element(name = models.CharField(max_length=50), audio= models.FileField(upload_to=None, max_length=100),volume= models.IntegerField())
    element2=Element(name = models.CharField(max_length=50), audio= models.FileField(upload_to=None, max_length=100),volume= models.IntegerField())
    element3=Element(name = models.CharField(max_length=50), audio= models.FileField(upload_to=None, max_length=100),volume= models.IntegerField())
    element4=Element(name = models.CharField(max_length=50), audio= models.FileField(upload_to=None, max_length=100),volume= models.IntegerField())
    element5=Element(name = models.CharField(max_length=50), audio= models.FileField(upload_to=None, max_length=100),volume= models.IntegerField())
'''
    