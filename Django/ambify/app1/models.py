from django.db import models

class Element(models.Model):
     name = models.CharField(max_length=50, null= True, verbose_name = "Name")
     audio= models.FileField(upload_to='Audios/', max_length=100, null= True, verbose_name = "Audio")
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
    
class History(models.Model):
     soundscape = models.ManyToManyField(Soundscape)  
     datetime = models.DateTimeField()

     def __str__(self):
          return self.soundscape
     