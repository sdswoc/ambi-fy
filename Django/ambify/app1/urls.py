from django.urls import path
from .views import play_audio, ElementListCreateView,SoundscapeListCreateView, HistoryListView


app_name = 'app1'

urlpatterns = [
    path('play_audio/<int:audio_file_id>/', play_audio, name='play_audio'),
    path('api/elements/', ElementListCreateView.as_view(), name='element-list-create'),
    path('api/soundscapes/',SoundscapeListCreateView.as_view(), name='soudscape-list-create'),
    path('api/history/', HistoryListView.as_view(), name= 'History-Viewset')
]
