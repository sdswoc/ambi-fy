# Generated by Django 5.0 on 2024-01-10 04:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app1', '0006_remove_element_volume'),
    ]

    operations = [
        migrations.CreateModel(
            name='History',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('datetime', models.DateTimeField()),
                ('soundscape', models.ManyToManyField(to='app1.soundscape')),
            ],
        ),
    ]
