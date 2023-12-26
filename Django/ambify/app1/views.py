from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from .models import Element, Soundscape
from pydub import AudioSegment
from rest_framework import generics
from .serializers import ElementSerializer, SoundscapeSerializer

def play_audio(request, audio_file_id):
    element = get_object_or_404(Element, id=audio_file_id)

    # Ensure that the audio field is not None before attempting to serve it
    if element.audio:
        # Open the audio file using pydub
        audio = AudioSegment.from_file(element.audio.path)

        # Convert the audio to WAV format (or any other format supported by browsers)
        audio_content = audio.export(format='wav').read()

        # Set up the response with the audio file content
        response = HttpResponse(audio_content, content_type='audio/wav')
        response['Content-Disposition'] = 'inline; filename="{}"'.format(element.name)

        return response


class ElementListCreateView(generics.ListCreateAPIView):
    queryset = Element.objects.all()
    serializer_class = ElementSerializer

class SoundscapeListCreateView(generics.ListCreateAPIView):
    queryset = Soundscape.objects.all()
    serializer_class = SoundscapeSerializer    

