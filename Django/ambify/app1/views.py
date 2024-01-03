from django.http import HttpResponse, FileResponse
from django.shortcuts import render, get_object_or_404
from .models import Element, Soundscape
from pydub import AudioSegment
from rest_framework import generics
from .serializers import ElementSerializer, SoundscapeSerializer
import os
from django.conf import settings

def play_audio(request, audio_file_id):
    element = get_object_or_404(Element, id=audio_file_id)

    if element.audio:
        audio = AudioSegment.from_file(element.audio.path)

        audio_content = audio.export(format='wav').read()

        response = HttpResponse(audio_content, content_type='audio/wav')
        response['Content-Disposition'] = 'inline; filename="{}"'.format(element.name)

        return response


class ElementListCreateView(generics.ListCreateAPIView):
    queryset = Element.objects.all()
    serializer_class = ElementSerializer

class SoundscapeListCreateView(generics.ListCreateAPIView):
    queryset = Soundscape.objects.all()
    serializer_class = SoundscapeSerializer
#
    #def get(self, request, *args, **kwargs):
    #    if 'audio' in request.GET:
    #        audio_file_path = request.GET['audio']
    #        audio_file = os.path.join(settings.MEDIA_ROOT, audio_file_path)
    #        return FileResponse(open(audio_file, 'rb'), content_type='audio/wav')
    #    return super().get(request, *args, **kwargs)
#
