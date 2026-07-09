<?php

namespace App\Http\Controllers;

use App\Models\Inquiry;
use Illuminate\Http\Request;

class InquiryReplyController extends Controller
{
    public function store(Request $request, $inquiryId)
    {
        $request->validate([
            'message' => ['required', 'string'],
        ]);

        $inquiry = Inquiry::findOrFail($inquiryId);

        if (auth('api')->user()->role === 'user' && $inquiry->user_id !== auth('api')->id()) {
            return response()->json([
                'status' => false,
                'message' => 'Akses ditolak',
                'data' => null,
            ], 403);
        }

        $reply = $inquiry->replies()->create([
            'user_id' => auth('api')->id(),
            'message' => $request->message,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Balasan berhasil dikirim',
            'data' => $reply->load('user'),
        ], 201);
    }
}
