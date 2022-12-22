"""
Django command to wait for the database to be availalbe.
"""
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    def handle(self, *args, **options):
        pass
