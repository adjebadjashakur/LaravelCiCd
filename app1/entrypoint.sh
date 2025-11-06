#!/bin/bash
 php artisan key:gen 
php artisan migrate
php artisan serve --host 0.0.0.0
