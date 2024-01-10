from django.http import HttpResponse, FileResponse
from django.shortcuts import render, get_object_or_404
from .models import Element, Soundscape, History
from pydub import AudioSegment
from rest_framework import generics
from rest_framework.views import APIView
from .serializers import ElementSerializer, SoundscapeSerializer, HistorySerializer
import os

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

class HistoryListCreateView(generics.ListCreateAPIView):
    queryset= History.objects.all()
    serializer_class= HistorySerializer

class HistoryViewSet(APIView):
    def get(self, request, id=None):
        if id:
            item = History.objects.get(id=id)
            serialize = HistorySerializer(item)
            return Response()