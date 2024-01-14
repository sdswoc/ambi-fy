from django.http import HttpResponse, FileResponse
from django.shortcuts import render, get_object_or_404
from .models import Element, Soundscape, History
from pydub import AudioSegment
from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
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

class HistoryListView(APIView):
    def get(self, request):
        histories = History.objects.all()
        serializer = HistorySerializer(histories, many=True)
        return Response({'status': 'success', 'data': serializer.data}, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = HistorySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'status': 'success', 'data': serializer.data}, status=status.HTTP_201_CREATED)
        else:
            return Response({'status': 'error', 'data': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        history = History.objects.get(id=id)
        history.delete()
        return Response({'status': 'success', 'data': 'History item removed!'}, status=status.HTTP_204_NO_CONTENT)
