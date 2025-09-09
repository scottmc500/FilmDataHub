"""
Local development settings for mysite project.
This file disables SSL for local MySQL connections.
"""

from .settings import *

# Override database settings for local development
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': env("DATABASE_NAME"),
        "USER": env("DATABASE_USERNAME"),
        "PASSWORD": env("DATABASE_PASSWORD"),
        "HOST": env("DATABASE_HOST"),
        "PORT": env("DATABASE_PORT"),
        # No SSL options for local development
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        }
    }
}

# Local development settings
DEBUG = True
ALLOWED_HOSTS = ["*"]

# Disable SSL redirect for local development
SECURE_SSL_REDIRECT = False
