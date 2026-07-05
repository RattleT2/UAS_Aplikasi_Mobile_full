<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:6', 'confirmed'],
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi gagal',
                'data' => $validator->errors(),
            ], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'user',
        ]);

        $token = auth('api')->login($user);

        return response()->json([
            'status' => true,
            'message' => 'Pendaftaran berhasil',
            'data' => [
                'user' => $user,
                'token' => $token,
                'token_type' => 'bearer',
            ],
        ], 201);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi gagal',
                'data' => $validator->errors(),
            ], 422);
        }

        $credentials = $request->only('email', 'password');

        if (!$token = auth('api')->attempt($credentials)) {
            return response()->json([
                'status' => false,
                'message' => 'Email atau password salah',
                'data' => null,
            ], 401);
        }

        return response()->json([
            'status' => true,
            'message' => 'Login berhasil',
            'data' => [
                'user' => auth('api')->user(),
                'token' => $token,
                'token_type' => 'bearer',
            ],
        ]);
    }

    public function logout()
    {
        auth('api')->logout();

        return response()->json([
            'status' => true,
            'message' => 'Logout berhasil',
            'data' => null,
        ]);
    }
}
