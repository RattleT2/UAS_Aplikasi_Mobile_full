<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\InquiryController;
use App\Http\Controllers\InquiryReplyController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/categories', [CategoryController::class, 'index']);

Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::post('/inquiries', [InquiryController::class, 'store']);
    Route::get('/inquiries', [InquiryController::class, 'index']);
    Route::get('/inquiries/{id}', [InquiryController::class, 'show']);

    Route::post('/inquiries/{inquiryId}/replies', [InquiryReplyController::class, 'store']);

    Route::middleware('check.role:admin')->group(function () {
        Route::get('/admin/inquiries', [InquiryController::class, 'adminIndex']);
        Route::get('/admin/inquiries/{id}', [InquiryController::class, 'adminShow']);
        Route::put('/admin/inquiries/{id}/status', [InquiryController::class, 'updateStatus']);
    });
});
