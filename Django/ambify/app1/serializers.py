from rest_framework import serializers
from .models import Element, Soundscape

class ElementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Element
        fields = '__all__'

class SoundscapeSerializer(serializers.ModelSerializer):
    elements = ElementSerializer(many=True, read_only=True)
    class Meta:
        model= Soundscape  
        fields= '__all__'      

