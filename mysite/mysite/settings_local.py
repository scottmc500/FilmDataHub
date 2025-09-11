"""
Local development settings for mysite project.
This file connects to MySQL running in Docker container without SSL.
"""

from .settings import *
import os

# Override database settings for local development
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('DATABASE_NAME', 'filmdatahub-db'),
        'USER': os.getenv('DATABASE_USERNAME', 'root'),
        'PASSWORD': os.getenv('DATABASE_PASSWORD', 'Pass123!'),
        'HOST': os.getenv('DATABASE_HOST', 'localhost'),
        'PORT': os.getenv('DATABASE_PORT', '3307'),
        # No SSL options for local development
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
            'charset': 'utf8mb4',
            'ssl_disabled': True,
        }
    }
}

# Local development settings
DEBUG = True
ALLOWED_HOSTS = ["*"]

# Disable SSL redirect for local development
SECURE_SSL_REDIRECT = False

# Logging for local development
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.db.backends': {
            'level': 'DEBUG',
            'handlers': ['console'],
        },
    },
}