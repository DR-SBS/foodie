from django.db import models

from taggit.managers import TaggableManager

from accounts.models import User


class Restaurant(models.Model):
    user = models.OneToOneField(User, related_name="restaurant", on_delete=models.CASCADE)
    website_link = models.URLField(max_length=200, blank=True)
    facebook_link = models.URLField(max_length=200, blank=True)
    logo = models.URLField(blank=True, max_length=1000)
    description = models.TextField(blank=True)
    open_hour = models.TimeField(auto_now=False, auto_now_add=False)
    close_hour = models.TimeField(auto_now=False, auto_now_add=False)
    is_available = models.BooleanField(default=True)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    tags = TaggableManager()

    class Meta:
        ordering = ('-is_available',)
    
    def __str__(self):
        return f'{self.user.full_name} for user {self.user.username}'