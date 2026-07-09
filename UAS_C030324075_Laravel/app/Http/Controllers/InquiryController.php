<?php

namespace App\Http\Controllers;

use App\Http\Requests\InquiryRequest;
use App\Models\Inquiry;
use Illuminate\Http\Request;

class InquiryController extends Controller
{
    public function store(InquiryRequest $request)
    {
        $inquiry = Inquiry::create([
            'user_id' => auth('api')->id(),
            'category_id' => $request->category_id,
            'nama' => $request->nama ?? auth('api')->user()->name,
            'email' => $request->email ?? auth('api')->user()->email,
            'website' => $request->website,
            'telp' => $request->telp,
            'pesan' => $request->pesan,
            'status' => 'open',
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Tiket berhasil dibuat',
            'data' => $inquiry->load('category'),
        ], 201);
    }

    public function index()
    {
        $inquiries = Inquiry::with('category')
            ->where('user_id', auth('api')->id())
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Data tiket berhasil diambil',
            'data' => $inquiries,
        ]);
    }

    public function show($id)
    {
        $inquiry = Inquiry::with(['category', 'replies.user'])
            ->where('user_id', auth('api')->id())
            ->findOrFail($id);

        return response()->json([
            'status' => true,
            'message' => 'Detail tiket berhasil diambil',
            'data' => $inquiry,
        ]);
    }

    public function adminIndex()
    {
        $inquiries = Inquiry::with(['user', 'category'])
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Data seluruh tiket berhasil diambil',
            'data' => $inquiries,
        ]);
    }

    public function adminShow($id)
    {
        $inquiry = Inquiry::with(['user', 'category', 'replies.user'])
            ->findOrFail($id);

        return response()->json([
            'status' => true,
            'message' => 'Detail tiket berhasil diambil',
            'data' => $inquiry,
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => ['required', 'in:open,in_progress,closed'],
        ]);

        $inquiry = Inquiry::findOrFail($id);
        $inquiry->update(['status' => $request->status]);

        return response()->json([
            'status' => true,
            'message' => 'Status tiket berhasil diubah',
            'data' => $inquiry->load('category'),
        ]);
    }
}
