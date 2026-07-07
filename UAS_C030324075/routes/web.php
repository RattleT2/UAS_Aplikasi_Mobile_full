<?php

use Illuminate\Support\Facades\Route;

Route::redirect('/', '/login');

Route::view('/login', 'auth.login')->name('login');
Route::view('/register', 'auth.register')->name('register');

Route::view('/dashboard', 'user.index')->name('user.dashboard');
Route::view('/dashboard/tickets/{id}', 'user.show')->name('user.ticket');

Route::view('/admin', 'admin.index')->name('admin.dashboard');
Route::view('/admin/tickets/{id}', 'admin.show')->name('admin.ticket');
